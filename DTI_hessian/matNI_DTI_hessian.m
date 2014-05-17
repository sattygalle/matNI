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

[gx,gy,gz] = gradient(img);
clear img;
[gxx, gxy, gxz] = gradient(gx);
clear gx;
[gyx, gyy, gyz] = gradient(gy);
clear gy;
[gzx, gzy, gzz] = gradient(gz);
clear gz;

totalvoxels = vol.dim(1)*vol.dim(2)*vol.dim(3);

maxeig = zeros(totalvoxels,1);

for i = 1:totalvoxels
    clear H;
H = [gxx(i) gxy(i) gxz(i) ; ...
    gyx(i) gyy(i) gyz(i); ...
    gzx(i) gzy(i) gzz(i)] ;

d = eigs(H,1);
maxeig(i) = d;
end


newimage =reshape(maxeig,vol.dim(1),vol.dim(2),vol.dim(3));
[pathstr, name, ext] = fileparts(vol.fname);

newfile = fullfile(pathstr, ['hess' name ext]);
newvol=vol;
newvol.fname = newfile;

spm_write_vol(newvol,newimage);

end
