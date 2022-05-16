function xq = myQuant(x,levels,range)
%
% myQuant function
% Output
% - xq: the quantized data
% Inputs
% - x: data to be quantized
% - levels: number of quantization levels to be employed
% - range: range of the quantizer, e.g. range = [-100 100]

bin = sum(abs(range))/levels;
x(x>=range(2)) = range(2)-(bin/2);
x(x<=range(1)) = range(1)+(bin/2);

xq = round(x./bin).*bin;


end
