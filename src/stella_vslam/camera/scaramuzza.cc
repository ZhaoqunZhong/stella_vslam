// Author: zhegushao
// Created date: Dec 8, 2022

#include "stella_vslam/camera/scaramuzza.h"
#include <iostream>
#include <spdlog/spdlog.h>
#include <nlohmann/json.hpp>

namespace stella_vslam {
namespace camera {

scaramuzza::scaramuzza(const std::string& name, const setup_type_t& setup_type, const color_order_t& color_order,
            const unsigned int cols, const unsigned int rows, const double fps,
            const std::vector<double> poly_para, const std::vector<double> inv_poly_para,
            const double C, const double D, const double E,
            const double center_x, const double center_y, const double max_angle) 
        : base(name, setup_type_t::Monocular, model_type_t::Scaramuzza, color_order, cols, rows, fps, 0.0, 0.0, 0.0),
        m_poly(poly_para), m_inv_poly(inv_poly_para), m_C(C), m_D(D), m_E(E), m_center_x(center_x), m_center_y(center_y),
        m_max_angle(max_angle), m_inv_scale(1.0 / (m_C - m_D * m_E)) {
    spdlog::debug("CONSTRUCT: camera::scaramuzza");
    img_bounds_ = compute_image_bounds();

    inv_cell_width_ = static_cast<double>(num_grid_cols_) / (img_bounds_.max_x_ - img_bounds_.min_x_);
    inv_cell_height_ = static_cast<double>(num_grid_rows_) / (img_bounds_.max_y_ - img_bounds_.min_y_);
}


scaramuzza::scaramuzza(const YAML::Node& yaml_node)
    : scaramuzza(yaml_node["name"].as<std::string>(),
              load_setup_type(yaml_node),
              load_color_order(yaml_node),
              yaml_node["cols"].as<unsigned int>(),
              yaml_node["rows"].as<unsigned int>(),
              yaml_node["fps"].as<double>(),
              yaml_node["polys"].as<std::vector<double>>(),
              yaml_node["inv_polys"].as<std::vector<double>>(), 
              yaml_node["C"].as<double>(),
              yaml_node["D"].as<double>(),
              yaml_node["E"].as<double>(),
              yaml_node["center_x"].as<double>(),
              yaml_node["center_y"].as<double>(),
              yaml_node["max_angle"].as<double>()) {}


scaramuzza::~scaramuzza() {
    spdlog::debug("DESTRUCT: camera::scaramuzza");
}


void scaramuzza::show_parameters() const {
    show_common_parameters();
    std::cout << "  - poly: ";
    for (auto a : m_poly) 
        std::cout << a << " ";
    std::cout << std::endl;
    std::cout << "  - inv poly: ";
    for (auto b : m_inv_poly) 
        std::cout << b << " ";
    std::cout << std::endl;
    std::cout << "  - C: " << m_C << std::endl;
    std::cout << "  - D: " << m_D << std::endl;
    std::cout << "  - E: " << m_E << std::endl;
    std::cout << "  - center_x: " << m_center_x << std::endl;
    std::cout << "  - center_y: " << m_center_y << std::endl;
    std::cout << "  - max_angle: " << m_max_angle << std::endl;
    std::cout << "  - min x: " << img_bounds_.min_x_ << std::endl;
    std::cout << "  - max x: " << img_bounds_.max_x_ << std::endl;
    std::cout << "  - min y: " << img_bounds_.min_y_ << std::endl;
    std::cout << "  - max y: " << img_bounds_.max_y_ << std::endl;
}

image_bounds scaramuzza::compute_image_bounds() const {
    spdlog::debug("compute image bounds");

    return image_bounds{0.0, cols_, 0.0, rows_};
}

cv::Point2f scaramuzza::undistort_point(const cv::Point2f& dist_pt) const {
    return dist_pt;
}

Vec3_t scaramuzza::convert_point_to_bearing(const cv::Point2f& undist_pt) const {
    // Relative to Center
    Eigen::Vector2d xc(undist_pt.x - m_center_x, undist_pt.y - m_center_y);

    // Affine Transformation
    // xc_a = inv(A) * xc;
    Eigen::Vector2d xc_a(
        m_inv_scale * (xc[0] - m_D * xc[1]),
        m_inv_scale * (-m_E * xc[0] + m_C * xc[1])
    );

    double phi = std::sqrt(xc_a[0] * xc_a[0] + xc_a[1] * xc_a[1]);
    double phi_i = 1.0;
    double z = 0.0;

    for (int i = 0; i < SCARAMUZZA_POLY_SIZE; i++)
    {
        z += phi_i * m_poly[i];
        phi_i *= phi;
    }

    // -z because scaramuzza's model is different than opencv camera model by the z direction
    return Vec3_t{xc_a[0], xc_a[1], -z};
}


cv::Point2f scaramuzza::convert_bearing_to_point(const Vec3_t& bearing) const {
    // bearing doesn't have to be normalized coord here
    double norm = std::sqrt(bearing(0) * bearing(0) + bearing(1) * bearing(1));
    double theta = std::atan2(-bearing(2), norm);
    double rho = 0.0;
    double theta_i = 1.0;

    for (int i = 0; i < SCARAMUZZA_INV_POLY_SIZE; i++)
    {
        rho += theta_i * m_inv_poly[i];
        theta_i *= theta;
    }

    double invNorm = 1.0 / norm;
    Eigen::Vector2d xn(
        bearing(0) * invNorm * rho,
        bearing(1) * invNorm * rho
    );

    return cv::Point2f(xn[0] * m_C + xn[1] * m_D + m_center_x,
    				   xn[0] * m_E + xn[1]       + m_center_y);
}

bool scaramuzza::reproject_to_image(const Mat33_t& rot_cw, const Vec3_t& trans_cw, const Vec3_t& pos_w, Vec2_t& reproj, float& x_right) const {
    // convert to camera-coordinates
    const Vec3_t pos_c = rot_cw * pos_w + trans_cw;

    // check if the point is visible
    double norm = std::sqrt(pos_c(0) * pos_c(0) + pos_c(1) * pos_c(1));
    double theta = std::atan2(norm, pos_c(2)); 
    if (theta * 180 / M_PI > m_max_angle) {
        return false;
    }

    // reproject onto the image
    double theta_inv_poly = std::atan2(-pos_c(2), norm);
    double rho = 0.0;
    double theta_i = 1.0;

    for (int i = 0; i < SCARAMUZZA_INV_POLY_SIZE; i++)
    {
        rho += theta_i * m_inv_poly[i];
        theta_i *= theta_inv_poly;
    }

    double invNorm = 1.0 / norm;
    Eigen::Vector2d xn(
        pos_c(0) * invNorm * rho,
        pos_c(1) * invNorm * rho
    );
    reproj(0) = xn[0] * m_C + xn[1] * m_D + m_center_x;
    reproj(1) = xn[0] * m_E + xn[1]       + m_center_y;
    const auto z_inv = 1.0 / pos_c(2);
    x_right = reproj(0) - focal_x_baseline_ * z_inv;


    // check if the point is visible
    return (img_bounds_.min_x_ < reproj(0) && reproj(0) < img_bounds_.max_x_
            && img_bounds_.min_y_ < reproj(1) && reproj(1) < img_bounds_.max_y_);
}


bool scaramuzza::reproject_to_bearing(const Mat33_t& rot_cw, const Vec3_t& trans_cw, const Vec3_t& pos_w, Vec3_t& reproj) const {
    // convert to camera-coordinates
    reproj = rot_cw * pos_w + trans_cw;

    // check if the point is visible
    double norm = std::sqrt(reproj(0) * reproj(0) + reproj(1) * reproj(1));
    double theta = std::atan2(norm, reproj(2)); 
    if (theta * 180 / M_PI > m_max_angle) {
        return false;
    }

    // reproject onto the image
    double theta_inv_poly = std::atan2(-reproj(2), norm);
    double rho = 0.0;
    double theta_i = 1.0;

    for (int i = 0; i < SCARAMUZZA_INV_POLY_SIZE; i++)
    {
        rho += theta_i * m_inv_poly[i];
        theta_i *= theta_inv_poly;
    }

    double invNorm = 1.0 / norm;
    Eigen::Vector2d xn(
        reproj(0) * invNorm * rho,
        reproj(1) * invNorm * rho
    );
    const auto x = xn[0] * m_C + xn[1] * m_D + m_center_x;
    const auto y = xn[0] * m_E + xn[1]       + m_center_y;

    // convert to a bearing
    reproj.normalize();

    // check if the point is visible
    return (img_bounds_.min_x_ < x && x < img_bounds_.max_x_
            && img_bounds_.min_y_ < y && y < img_bounds_.max_y_);
}

nlohmann::json scaramuzza::to_json() const {
    return {{"model_type", get_model_type_string()},
            {"setup_type", get_setup_type_string()},
            {"color_order", get_color_order_string()},
            {"cols", cols_},
            {"rows", rows_},
            {"fps", fps_},
            {"focal_x_baseline", focal_x_baseline_},
            {"num_grid_cols", num_grid_cols_},
            {"num_grid_rows", num_grid_rows_},
            {"poly_paras", m_poly},
            {"inv_poly_paras", m_inv_poly},
            {"C", m_C},
            {"D", m_D},
            {"E", m_E},
            {"center_x", m_center_x},
            {"center_y", m_center_y},
            {"max_angle", m_max_angle}
        };
}

std::ostream& operator<<(std::ostream& os, const scaramuzza& params) {
    os << "- name: " << params.name_ << std::endl;
    os << "- setup: " << params.get_setup_type_string() << std::endl;
    os << "- fps: " << params.fps_ << std::endl;
    os << "- cols: " << params.cols_ << std::endl;
    os << "- rows: " << params.rows_ << std::endl;
    os << "- color: " << params.get_color_order_string() << std::endl;
    os << "- model: " << params.get_model_type_string() << std::endl;
    std::cout << "  - poly: ";
    for (auto a : params.m_poly) 
        std::cout << a << " ";
    std::cout << std::endl;
    std::cout << "  - inv poly: ";
    for (auto b : params.m_inv_poly) 
        std::cout << b << " ";
    std::cout << std::endl;
    std::cout << "  - C: " << params.m_C << std::endl;
    std::cout << "  - D: " << params.m_D << std::endl;
    std::cout << "  - E: " << params.m_E << std::endl;
    std::cout << "  - center_x: " << params.m_center_x << std::endl;
    std::cout << "  - center_y: " << params.m_center_y << std::endl;
    std::cout << "  - max_angle: " << params.m_max_angle << std::endl;
    os << "  - min x: " << params.img_bounds_.min_x_ << std::endl;
    os << "  - max x: " << params.img_bounds_.max_x_ << std::endl;
    os << "  - min y: " << params.img_bounds_.min_y_ << std::endl;
    os << "  - max y: " << params.img_bounds_.max_y_ << std::endl;
    return os;
}

//! Override for optimization

void scaramuzza::undistort_points(const std::vector<cv::Point2f>& dist_pts, std::vector<cv::Point2f>& undist_pts) const {
    undist_pts = dist_pts;
}

void scaramuzza::undistort_keypoints(const std::vector<cv::KeyPoint>& dist_keypts, std::vector<cv::KeyPoint>& undist_keypts) const {
    undist_keypts = dist_keypts;
}

} //namespace camera
} //namespace stella_vslam