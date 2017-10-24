% Fast 3d bilateral filter for unit8 images
% Coded by FST
%
% F. Porikli, “Constant time O (1) bilateral filtering,” Comput. Vis.
% Pattern Recognition, 2008. CVPR 2008. IEEE Conf., no. 1, pp. 1–8, 2008.
%
% Usage:
%   Ibf = bf3(I, spatialSize, rangeSigma)
%
%   I: input 3d image
%
%   spatialSize:    window size of spatial filtering
%                   (in terms of pixels)
%                   spatialSize can be very large 
%                   and does not effect computation time
%
%   rangeSigma:     sigma size of range filtering 
%                   (in terms of 0-255 gray values)
%
% Example:
%   Ibf = bf3(I,7,10);
%

function Ibf = bf3(I, spatialSize, rangeSigma)

    global BINS R;
    
    BINS = 16;
    R = 256 / BINS;
    
    [sz,sy,sx] = size(I);
    k = gkernel(rangeSigma);
    
    Iq = uint8(1 + floor(double(I) ./ R));
    Ibins = zeros(BINS, sz, sy, sx);
    Ibins_int = zeros(BINS, sz+1, sy+1, sx+1);
    for b = 1:BINS
        Ibins(b,:,:,:) = (Iq(:,:,:) == b);
        Ibins_int(b,:,:,:) = integralImage3(squeeze(Ibins(b,:,:,:)));
    end
    
    hWindow = uint8(spatialSize / 2);
    Ibf = zeros(sz,sy,sx);
    for z = 1:sz
        eR = z + hWindow;
        sR = z - hWindow;
        if sR < 1
            sR = 1;
        end
        if eR > sz
            eR = sz;
        end
        for y = 1:sy
            eC = y + hWindow;
            sC = y - hWindow;
            if sC < 1
                sC = 1;
            end
            if eC > sy
                eC = sy;
            end
            for x = 1:sx
                eP = x + hWindow;
                sP = x - hWindow;
                if sP < 1
                    sP = 1;
                end
                if eP > sx
                    eP = sx;
                end
                tw = 0;
                ws = 0;
                for b = 1:BINS
                    d = 1 + abs(Iq(z,y,x) - b);
                    s = Ibins_int(b,eR+1,eC+1,eP+1) ...
                          - Ibins_int(b,eR+1,eC+1,sP) ...
                          - Ibins_int(b,eR+1,sC,eP+1) ...
                          - Ibins_int(b,sR,eC+1,eP+1) ...
                          + Ibins_int(b,sR,sC,eP+1) ...
                          + Ibins_int(b,sR,eC+1,sP) ... 
                          + Ibins_int(b,eR+1,sC,sP) ...
                          - Ibins_int(b,sR,sC,sP); 
                    w = s * k(d);
                    tw = tw + w;
                    ws = ws + (b-1) * w;
                end
                ws = ws / (tw * (BINS - 1));
                Ibf(z,y,x) = uint8(255 * ws);
            end
        end
    end
end

function h = gkernel(stdev)
    global BINS R;
    h=exp(-0.5 * R * ((0:BINS-1) / stdev).^2);
    h=h./sum(h);
end
