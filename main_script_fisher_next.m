function main_script_fisher_next()

clear all;
[female_set_landmarks,male_set_landmarks]=load_male_female_landmarks();
total_set_landmarks=[female_set_landmarks male_set_landmarks];
%Calculate mean
female_mean_landmarks = get_mean_image_vector(female_set_landmarks);
male_mean_landmarks = get_mean_image_vector(male_set_landmarks);
total_set_landmarks=[female_set_landmarks male_set_landmarks];
%SVD Calculation
rep_landmarks = double(total_set_landmarks') * double(total_set_landmarks);
[u2,l2,v2] = svd(rep_landmarks);
[r,c] = size(u2);
ce2 = double(total_set_landmarks) * u2;
for i=1:c
  eigen_landmarks(:,i) =  u2(:,i) /norm(u2(:,i));
  a2(:,i) =  (ce2(:,i)/norm(ce2(:,i))) .*sqrt(l2(i,i));
end
%Equations calculated as per PDF Explanation
y2 = a2' * (female_mean_landmarks - male_mean_landmarks);
z2 = inv(l2*l2*eigen_landmarks') * y2;
w2 = double(total_set_landmarks)*z2;


[female_set_images,male_set_images]=load_female_male_images();
total_set_images=[female_set_images male_set_images];
%Calculate mean
female_mean = get_mean_image_vector(female_set_images);
male_mean = get_mean_image_vector(male_set_images);
%SVD Calculation
rep_images = double(total_set_images') * double(total_set_images);
[u,l,v] = svd(rep_images);
[r,c] = size(u);
ce = double(total_set_images) * u;
for i=1:c
  eigen_vectors(:,i) =  u(:,i) /norm( u(:,i));
  a(:,i) =  (ce(:,i)/norm(ce(:,i))) .*sqrt(l(i,i));
end
%Equations calculated as per PDF Explanation
y = a' * (female_mean - male_mean);
z = inv(l*l*eigen_vectors') * y;
w = double(total_set_images)*z;


% Reading ALL TEST IMAGES and TEST LANDMARKS
[female_set_landmarks_test,male_set_landmarks_test]=load_male_female_landmarks_test();
[female_set_images_test,male_set_images_test]=load_female_male_test_images();

size(female_set_landmarks_test)
size(male_set_landmarks_test)
clear y2;
% Computations for the SCATTER PLOT
for i=1:10
  x1(i) = w'* double(female_set_images_test(:,i));
  y1(i) = w2' * double(female_set_landmarks_test(:,i));
  x2(i) = w'* double(male_set_images_test(:,i));
  y2(i) = w2' * double(male_set_landmarks_test(:,i));
end
size(x1)
size(y1)

size(x2)
size(y2)

figure;
scatter(x1,y1);
hold all;

scatter(x2,y2,'filled');
hold all;
x=[ 0 ; 0 ];
y=[ -0.1 ; 0.1];
plot(x,y);

end

