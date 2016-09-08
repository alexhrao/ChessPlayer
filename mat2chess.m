function strPosn = mat2chess(vecPosn)
strPosn = 'a':'h';
strPosn(1) = strPosn(vecPosn(1));
strPosn(2) = num2str(vecPosn(2));
strPosn = strPosn(1:2);
end