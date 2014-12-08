"""
Purpose:
  Set of codes to work with viewing angles of quasars (or any other kind of object with a disk-like shape.  Given a number of objects and a critical angle where the object type changes (e.g. type 1 or 2 quasars), the "main" function will just tell you how many objects you have of each type.

Input output angles are in degrees

Authors:
  Mike DiPompeo (UWyo)

History:
  12-8-14  Written
"""
import os
import sys
import re
import numpy as np
from scipy.integrate import quad

#Determines number of face-on (theta < theta_c) things
def n_face(n,theta_c,down=0,up=0):
    if theta_c == 0:
        num_face = 0
    if theta_c == 90:
        num_face = n
    if theta_c != 0 and theta_c != 90:
        prob = quad(np.sin, 0, np.radians(theta_c))
        num_face = n * prob[0]
    
    if down == 1:
        num_face = np.floor(num_face)
    if up == 1:
        num_face = np.ceil(num_face)
    if down == 0 and up == 0:
        num_face = round(num_face)

    return num_face

#Determines number of edge-on (theta > theta_c) things
def n_edge(n,theta_c,down=0,up=0):
    if theta_c == 0:
        num_edge = n
    if theta_c == 90:
        num_edge = 0
    if theta_c != 0 and theta_c != 90:
        prob = quad(np.sin, np.radians(theta_c), np.pi/2.)
        num_edge = n * prob[0]

    if down == 1:
        num_edge = np.floor(num_edge)
    if up == 1:
        num_edge = np.ceil(num_edge)
    if down == 0 and up == 0:
        num_edge = round(num_edge)

    return num_edge

#Generates random viewing angles to face on (kind=1) or edge-on (kind=2) samples
def viewing_angles(n,theta_c,kind=1,seed=0):
    if seed != 0:
        np.random.seed(seed=seed)

    angs = np.random.random_sample(n)

    if kind == 1:
        angles = np.arccos(1-angs*(1-np.cos(np.radians(theta_c))))
    if kind == 2:
        angles = np.arccos(np.cos(np.radians(theta_c))-angs*np.cos(np.radians(theta_c)))

    return np.degrees(angles)

def main():
    args = sys.argv[1:]
    if not args:
        print 'usage: python orient.py n crit_angle (in degrees)'

    n = float(args[0])
    theta_c = float(args[1])

    nobsc = n_edge(n, theta_c)
    nunob = n_face(n, theta_c)

    print 'N_edge = ',nobsc
    print 'N_face = ',nunob

    edge_vecs = viewing_angles(n, theta_c, kind=2)
    face_vecs = viewing_angles(n, theta_c, kind=1)

if __name__ == '__main__':
    main()
