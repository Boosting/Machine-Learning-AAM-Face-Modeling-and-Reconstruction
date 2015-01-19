function [test_image_weight] = get_weights_random(e_faces,test_set_image_shifted)
%Find weights of the given test face.
%Output: Weights of test face wrt to the Eigen Faces as a Column Vector

[r,c]=size(e_faces);
r= -1 + (1+1)*rand(c,1);
%test_image_weight=double(e_faces)'*double(test_set_image_shifted);
test_image_weight=r;

end

