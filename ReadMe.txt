===============================
 Canny Edge Detection DEMO
 Yinjie Huang
 RET Project
 University of Central Florida
 2012
===============================



==================================
=========
CONTENTS:
=========

1. General Information
2. Requirements
3. Installation
4. Usage
5. References

==================================

1. GENERAL INFORMATION

This software was written as the demo of RET project Summer 2012. It represents an implementation of canny edge detection algorihm, including a complete graphical user interface (GUI). All rights belong to the author.



2. REQUIREMENTS

To run this software, you need to have the following components installed:
- Mathworks MATLAB
- Mathworks Image Processing Toolbox



3. INSTALLATION

This software doesn't require any installation. Just drop the files into a folder.



4. USAGE

To run the software, run the file 'Main.m' or type in 'Main' in the MATLAB command window. The script will take care of all the rest and start a graphical user interface. 

The basic usage is as follows:
- Go to menu and open one image.
- Set the High and Low threshold (between 0 and 1) or use the values by default.
- Input the size of Gaussian Filter (odd number such as 1, 3, 5,...) and Sigma for filter.
- Click once 'Run Canny By One Click', all the results will be shown. Or you could do the Canny Edge Detection step by step by clicking each button.
- Click "Show Edges", the edges on the original image will pop out.
- Image could also be saved through button 'Save'.



5. References

- http://www.cse.iitd.ernet.in/~pkalra/csl783/canny.pdf
- http://homepage.cs.uiowa.edu/~cwyman/classes/spring08-22C251/homework/canny.pdf
- http://en.wikipedia.org/wiki/Canny_edge_detector
