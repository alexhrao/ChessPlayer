function vecPosn = chess2mat(strPosn)
vecPosn = zeros(1, 2);
vecPosn(1) = lower(strPosn(1)) - 96;
vecPosn(2) = str2double(strPosn(2));
end