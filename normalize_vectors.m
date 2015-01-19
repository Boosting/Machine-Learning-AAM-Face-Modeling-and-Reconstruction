function [ output_vector] = normalize_vectors( input_vector)
%UNTITLED19 Summary of this function goes here
%   Detailed explanation goes here

[r,c]=size(input_vector);
output_vector=[];
for i=1:c
        min_val=min(double(input_vector(:,i)));
        max_val=max(double(input_vector(:,i)));
        if(min_val<=0)
            output_vector(:,i)=round(((double(input_vector(:,i))+(-1*min_val))/(max_val+(-1)*min_val))*255);
        end
end
end

