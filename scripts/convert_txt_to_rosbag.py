#!/usr/bin/env python
import rosbag
import rospy
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.dates as mdates
from datetime import datetime
from nav_msgs.msg import Odometry
# from geometry_msgs import Pose, Quaternion
import re
import sys
import os

def is_float(value):
    try:
        float(value)
        return True
    except:
        return False

def parse_log_file(pose_file):
    fin = open(pose_file, "r")
    text = fin.readlines()
    fin.close()
    bag = rosbag.Bag('frame_pose.bag', 'w')
    for line in text:
            pose = str.split(line, ' ')
            # print pose
            if len(pose) == 8:
                # print pose
                odom = Odometry()
                odom.header.stamp = rospy.Time.from_sec(float(pose[0]))
                odom.header.frame_id = "vslam"
                # set the position
                odom.pose.pose.position.x = float(pose[1])
                odom.pose.pose.position.y = float(pose[2])
                odom.pose.pose.position.z = float(pose[3])
                odom.pose.pose.orientation.x = float(pose[4])
                odom.pose.pose.orientation.y = float(pose[5])
                odom.pose.pose.orientation.z = float(pose[6])
                odom.pose.pose.orientation.w = float(pose[7])
                # print odom.pose.pose.orientation.w
                bag.write('/vslam_pose', odom, odom.header.stamp)
    bag.close()
if __name__ == "__main__":
    if(len(sys.argv) == 2):
        if(os.path.isfile(sys.argv[1]) == True):
            parse_log_file(sys.argv[1])
    else:
        print ("param number is %d, not equal to 2!" %(len(sys.argv)))
        sys.exit(-1)




