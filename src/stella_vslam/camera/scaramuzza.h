// Author: zhegushao
// Created date: Dec 8, 2022

#pragma once

#include "stella_vslam/camera/base.h"

namespace stella_vslam {
namespace camera {

#define SCARAMUZZA_POLY_SIZE 5
#define SCARAMUZZA_INV_POLY_SIZE 14
// #define SCARAMUZZA_CAMERA_NUM_PARAMS (SCARAMUZZA_POLY_SIZE + SCARAMUZZA_INV_POLY_SIZE + 2 /*center*/ + 3 /*affine*/)


class scaramuzza final : public base {
public:
    EIGEN_MAKE_ALIGNED_OPERATOR_NEW

    scaramuzza(const std::string& name, const setup_type_t& setup_type, const color_order_t& color_order,
            const unsigned int cols, const unsigned int rows, const double fps,
            const std::vector<double> poly_para, const std::vector<double> inv_poly_para, const double C, const double D, const double E,
            const double center_x, const double center_y, const double max_angle);

    scaramuzza(const YAML::Node& yaml_node);

    ~scaramuzza() override;

    void show_parameters() const override final;

    image_bounds compute_image_bounds() const override final; 

    cv::Point2f undistort_point(const cv::Point2f& dist_pt) const override final;

    Vec3_t convert_point_to_bearing(const cv::Point2f& undist_pt) const override final;

    cv::Point2f convert_bearing_to_point(const Vec3_t& bearing) const override final;

    bool reproject_to_image(const Mat33_t& rot_cw, const Vec3_t& trans_cw, const Vec3_t& pos_w, Vec2_t& reproj, float& x_right) const override final;

    bool reproject_to_bearing(const Mat33_t& rot_cw, const Vec3_t& trans_cw, const Vec3_t& pos_w, Vec3_t& reproj) const override final;

    nlohmann::json to_json() const override final;

    //! Override for optimization
    void undistort_points(const std::vector<cv::Point2f>& dist_pts, std::vector<cv::Point2f>& undist_pts) const override final;
    void undistort_keypoints(const std::vector<cv::KeyPoint>& dist_keypt, std::vector<cv::KeyPoint>& undist_keypt) const override final;

    //-------------------------
    // Parameters specific to this model
    std::vector<double> m_poly;
    std::vector<double> m_inv_poly;
    double m_C;
    double m_D;
    double m_E;
    double m_center_x;
    double m_center_y;
    double m_max_angle;

    double m_inv_scale;

}; // class scaramuzza

std::ostream& operator<<(std::ostream& os, const scaramuzza& params);

} // namespace camera
} // namespace stella_vslam
