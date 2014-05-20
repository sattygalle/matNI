function  matNI_DTI_hessian( pathtoimage )
%MATNI_DTI_HESSIAN - compute hessian and apply to 3D image
%   compute hessian and apply to 3D image and saves image in location of
%   processed image. Requires SPM.
%
% Syntax: matNI_DTI_hessian( pathtoimage)
%
% Inputs: pathtoimage - string containing full path to image to apply
% filter
%   
% Outputs: filtered image with "hess" prepended to original filename
%
% Other m-files required:  SPM
% Subfunctions:
%
% MAT-files required: SPM, Image Processing toolbox
%
% See also:
%
% To Do: 
%
% Author: Suneth Attygalle, UCSF Memory and Aging Center
% Created 05/16/2014
% Revisions:
vol = spm_vol(pathtoimage);
img = spm_read_vols(vol);
% gaussianfilter =  fspecial('gaussian',[6 6], 1);
% img= imfilter(img, gaussianfilter);
scalingfactor = 1; 
totalvoxels = vol.dim(1)*vol.dim(2)*vol.dim(3);

[gx,gy,gz] = gradient(img);
clear img;
[gxx, gxy, gxz] = gradient(gx);
clear gx;
[gyx, gyy, gyz] = gradient(gy);
clear gy;
[gzx, gzy, gzz] = gradient(gz);
clear gz;

gxx =reshape(gxx, 1,totalvoxels) ;
gxy =reshape(gxy, 1,totalvoxels) ;
gxz =reshape(gxz, 1,totalvoxels) ;
gyx =reshape(gyz, 1,totalvoxels) ;
gyy =reshape(gyy, 1,totalvoxels) ;
gyz =reshape(gyz, 1,totalvoxels) ;
gzx =reshape(gzx, 1,totalvoxels) ;
gzy =reshape(gzy, 1,totalvoxels) ;
gzz =reshape(gzz, 1,totalvoxels) ;

H(1,1,:) = gxx;
H(2,1,:) = gyx;
H(3,1,:) = gzx;
H(1,2,:) = gxy;
H(2,2,:) = gyy;
H(3,2,:) = gzy;
H(1,3,:) = gzz;
H(2,3,:) = gyz;
H(3,3,:) = gzz;

D=eig3(H);

maxeig= max(D);


newimage =reshape(maxeig,vol.dim(1),vol.dim(2),vol.dim(3));
[pathstr, name, ext] = fileparts(vol.fname);

newfile = fullfile(pathstr, ['hess' name ext]);
newvol=vol;
newvol.fname = newfile;

spm_write_vol(newvol,newimage);
end
