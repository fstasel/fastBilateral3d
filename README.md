# fastBilateral3d
Fast 3D Bilateral filtering in O(1) time for MATLAB uint8 images
Coded by FST

F. Porikli, “Constant time O (1) bilateral filtering,” Comput. Vis.
Pattern Recognition, 2008. CVPR 2008. IEEE Conf., no. 1, pp. 1–8, 2008.

Usage:
   Ibf = bf3(I, spatialSize, rangeSigma)

   I: input 3d image

   spatialSize:    window size of spatial filtering
                   (in terms of pixels)
                   spatialSize can be very large 
                   and does not effect computation time

   rangeSigma:     sigma size of range filtering 
                   (in terms of 0-255 gray values)

 Example:
   Ibf = bf3(I,7,10);
