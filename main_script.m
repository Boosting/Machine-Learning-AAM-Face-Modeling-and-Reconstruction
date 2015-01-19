function main_script()
%--------------------------------------------------------------------------
clear all;
close all;

%Display MEAN Image -Works!
[training_set_images,test_set_images]=load_0_176_images();
mean_image_vector=get_mean_image_vector(training_set_images);
display_faces(mean_image_vector);

%%Display k=20 EIGEN FACES - Works!
mean_reduced_images=mean_reduced_matrix(training_set_images,mean_image_vector);

[e_vectors_reduced,e_values_reduced]=reduced_pca(mean_reduced_images,20);       %k_val = 20
%for j=1:20
%        e_vectors_reduced(:,j) = e_vectors_reduced(:,j)/norm(e_vectors_reduced(:,j));
%end
e_faces=get_eigen_faces(mean_reduced_images,e_vectors_reduced);
for j=1:20
        e_faces(:,j) = e_faces(:,j)/norm(e_faces(:,j));
end
display_faces(e_faces,mean_image_vector);

%for j=1:20
%        e_vectors_reduced(:,j) = e_vectors_reduced(:,j)/norm(e_vectors_reduced(:,j));
%end
%Display 27 Reconstructed TEST Faces - Does it work? --- YES, it does! - Works!
reconstructed_test_faces=reconstruct_test_faces(e_faces,test_set_images,mean_image_vector);

display_faces(reconstructed_test_faces,mean_image_vector);

%Plotting of Reconstruction Error 
plot_reconstruction_error(training_set_images,test_set_images,mean_reduced_images,mean_image_vector);


%--------------------------------------------------------------------------
%%Display MEAN landmarks
[training_set_landmarks,test_set_landmarks]=load_0_176_landmark_images();
%size(training_set_landmarks)
%size(test_set_landmarks)
mean_landmark_vector=get_mean_image_vector(training_set_landmarks);
display_landmarks(mean_landmark_vector,mean_landmark_vector);

%%Display 5 Eigen warpings
mean_reduced_training_landmarks=mean_reduced_matrix(training_set_landmarks,mean_landmark_vector);
caricature=mean_reduced_training_landmarks*mean_reduced_training_landmarks';
[e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,5);
e_warpings=e_vectors_reduced;
display_landmarks(e_warpings,mean_landmark_vector);

%%Display 27 TEST Warpings
reconstructed_test_landmarks=reconstruct_test_landmarks(e_warpings,test_set_landmarks,mean_landmark_vector);% Mean added back for Display
display_landmarks(reconstructed_test_landmarks,mean_landmark_vector);

%%Plot Reconstruction ERROR Curve
plot_landmark_reconstruction_error(training_set_landmarks,test_set_landmarks,mean_landmark_vector);

%--------------------------------------------------------------------------
%Part 3 

%At this point, Following are used from Previous Code - 
%1)training_set_images 2) test_set_images 3) mean_image_vector
%4)mean_reduced_images 5)training_set_landmarks 6)test_set_landmarks
%7)mean_reduced_landmarks 

% (i)  - Get top 10 eigen landmarks, Diplay Eigen landmarks, Reconstruct Test
%Landmarks from Top 10 Eigen Landmarks 

%DISPLAY MEAN LANDMARKS
caricature=mean_reduced_training_landmarks*mean_reduced_training_landmarks';
[e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,10);
e_warpings=e_vectors_reduced;
display_landmarks(e_warpings,mean_landmark_vector);

%%%DISPLAY 27 RECONSTRUCTED TEST Warpings(LANDMARKS)
reconstructed_test_landmarks=reconstruct_test_landmarks(e_warpings,test_set_landmarks,mean_landmark_vector);% Mean added back for Display
display_landmarks(reconstructed_test_landmarks,mean_landmark_vector);

% (ii) - Warp Training Faces to Mean Landmarks FROM Original Training face
% landmarks, Get the Top 10 EIGEN FACES,Display Top 10 Eigen Faces,
% Reconstruct the Test Faces to Top 10 Eigen Faces ( Display) 

%%MEAN WARP TRAINING IMAGES one at a time
[r,c]=size(training_set_images);
mean_landmarks_matrix=reshape(mean_landmark_vector,[87,2]);
training_images_mean_warpped=[];
for i=1:c %Output: training_images_mean_warpped
    training_images_matrix=reshape(training_set_images(:,i),[256,256]);
    training_landmarks_matrix=reshape(training_set_landmarks(:,i),[87,2]);
    training_images_mean_warpped_matrix=warpImage_kent(training_images_matrix,training_landmarks_matrix,mean_landmarks_matrix);
    training_images_mean_warpped=[training_images_mean_warpped  reshape(training_images_mean_warpped_matrix,[256*256,1])];
end

%%TOP 10 EIGEN FACES & DISPLAY Top 10 Eigen Faces %should I decrease5
%%the mean here? ------- Not needed. 
%size(mean_reduced_images)
%size(training_images_mean_warpped)
mean_warpped_image_vector=get_mean_image_vector(training_images_mean_warpped);
mean_reduced_images_w=mean_reduced_matrix(training_images_mean_warpped,mean_warpped_image_vector);
[e_vectors_reduced_w,e_values_reduced_w]=reduced_pca(mean_reduced_images_w,10);       %k_val = 20
e_faces_w=get_eigen_faces(mean_reduced_images_w,e_vectors_reduced_w);
for j=1:10
        e_faces_w(:,j) = e_faces_w(:,j)/norm(e_faces_w(:,j));
end
display_faces(e_faces_w,mean_warpped_image_vector);

%%DISPLAY RECONSTRUCTION of top 27 Test Faces using Top 10 Eigen 
reconstructed_test_faces_w=reconstruct_test_faces(e_faces_w,test_set_images,mean_warpped_image_vector);
display_faces(reconstructed_test_faces_w,mean_warpped_image_vector);

% (iii) WARP Reconstructed TEST FACES from mean position to RECONSTRUCTED
% Landmarks Position, For all k_val compute Reconstruction ERROR

%DISPLAY "RE"-WARP RECONSTRUCTED TEST IMAGES to reconstructed test Landmarks 
reconstructed_test_images_rewarpped=[];
[r,c]=size(reconstructed_test_faces_w);
for i=1:c
    recon_test_image_matrix=reshape(reconstructed_test_faces_w(:,i),[256,256]);
    recon_test_landmark_matrix=reshape(reconstructed_test_landmarks(:,i),[87,2]);
    recon_test_image_landmark_warpped_matrix=warpImage_kent(recon_test_image_matrix,mean_landmarks_matrix,recon_test_landmark_matrix);
    reconstructed_test_images_rewarpped=[reconstructed_test_images_rewarpped reshape(recon_test_image_landmark_warpped_matrix,[256*256,1])];
end
reconstructed_test_images_rewarpped=double(reconstructed_test_images_rewarpped);

display_faces(reconstructed_test_images_rewarpped,mean_warpped_image_vector);

% PLOT RECONSTRUCTION ERROR CURVE for ALL K   ----  Now Landmarks are ALLIGNED!!!  


disp('Entering....');
for k_val=1:150
    % For Landmarks 
    disp('#3');
    disp(k_val);
    [e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,k_val);
    e_warpings=e_vectors_reduced;
    
    reconstructed_test_landmarks=reconstruct_test_landmarks(e_warpings,test_set_landmarks,mean_landmark_vector);% Mean added back for Display
    
    % For Faces
    [e_vectors_reduced_w,e_values_reduced_w]=reduced_pca(mean_reduced_images_w,k_val);       %k_val = 20
    e_faces_w=get_eigen_faces(mean_reduced_images_w,e_vectors_reduced_w);
    for j=1:k_val
        e_faces_w(:,j) = e_faces_w(:,j)/norm(e_faces_w(:,j));
    end
    reconstructed_test_faces_w=reconstruct_test_faces(e_faces_w,test_set_images,mean_warpped_image_vector);
   
    reconstructed_test_images_rewarpped=[];
    [r,c]=size(reconstructed_test_faces_w);
    for i=1:c
        recon_test_image_matrix=reshape(reconstructed_test_faces_w(:,i),[256,256]);
        recon_test_landmark_matrix=reshape(reconstructed_test_landmarks(:,i),[87,2]);
        recon_test_image_landmark_warpped_matrix=warpImage_kent(recon_test_image_matrix,mean_landmarks_matrix,recon_test_landmark_matrix);
        reconstructed_test_images_rewarpped=[reconstructed_test_images_rewarpped reshape(recon_test_image_landmark_warpped_matrix,[256*256,1])];
    end
    reconstructed_test_images_rewarpped=double(reconstructed_test_images_rewarpped);
    
    diff=double(test_set_images)-reconstructed_test_images_rewarpped;
    reconstruction_error_alligned(k_val)=sum(sum(diff.^2))/(256*256*27);
    
end


figure;
x=1:1:150;
plot(x,reconstruction_error_alligned(1:150));
%--------------------------------------------------------------------------
%Part 4 
%Same as Part 3, but here the weights are randomly generated.. 

%Generating RANDOM SAMPLING of Landmarks from Test Images, 

%(!!!!)

caricature=mean_reduced_training_landmarks*mean_reduced_training_landmarks';
[e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,10);
e_warpings=e_vectors_reduced;
reconstructed_test_landmarks=reconstruct_test_landmarks_random(e_warpings,test_set_landmarks,mean_landmark_vector,e_values_reduced(1,1));% Mean added back for Display
display_landmarks(reconstructed_test_landmarks,mean_landmark_vector);

%MEAN WARP TRAINING IMAGES one at a time
[r,c]=size(training_set_images);
mean_landmarks_matrix=reshape(mean_landmark_vector,[87,2]);
training_images_mean_warpped=[];
for i=1:c %Output: training_images_mean_warpped
    training_images_matrix=reshape(training_set_images(:,i),[256,256]);
    training_landmarks_matrix=reshape(training_set_landmarks(:,i),[87,2]);
    training_images_mean_warpped_matrix=warpImage_kent(training_images_matrix,training_landmarks_matrix,mean_landmarks_matrix);
    training_images_mean_warpped=[training_images_mean_warpped  reshape(training_images_mean_warpped_matrix,[256*256,1])];
end

%TOP 10 EIGEN FACES & DISPLAY Top 10 Eigen Faces %should I decrease
%the mean here? ------- Not needed. 
size(mean_reduced_images)
size(training_images_mean_warpped)
mean_warpped_image_vector=get_mean_image_vector(training_images_mean_warpped);
mean_reduced_images_w=mean_reduced_matrix(training_images_mean_warpped,mean_warpped_image_vector);
[e_vectors_reduced_w,e_values_reduced_w]=reduced_pca(mean_reduced_images_w,10);       %k_val = 20
e_faces_w=get_eigen_faces(mean_reduced_images_w,e_vectors_reduced_w);
for j=1:10
        e_faces_w(:,j) = e_faces_w(:,j)/norm(e_faces_w(:,j));
end
display_faces(e_faces_w,mean_warpped_image_vector);

%DISPLAY RECONSTRUCTION of top 27 Test Faces using Top 10 Eigen
%(!!!!)
reconstructed_test_faces_w=reconstruct_test_faces_random(e_faces_w,test_set_images,mean_warpped_image_vector,e_values_reduced_w(1,1));
display_faces(reconstructed_test_faces_w,mean_warpped_image_vector);


%DISPLAY "RE"-WARP RECONSTRUCTED TEST IMAGES to reconstructed test Landmarks 
%reconstructed_test_images_rewarpped=[];
reconstructed_test_images_rewarpped=[];
[r,c]=size(reconstructed_test_faces_w);
for i=1:c
    recon_test_image_matrix=reshape(reconstructed_test_faces_w(:,i),[256,256]);
    recon_test_landmark_matrix=reshape(reconstructed_test_landmarks(:,i),[87,2]);
    recon_test_image_landmark_warpped_matrix=warpImage_kent(recon_test_image_matrix,mean_landmarks_matrix,recon_test_landmark_matrix);
    reconstructed_test_images_rewarpped=[reconstructed_test_images_rewarpped reshape(recon_test_image_landmark_warpped_matrix,[256*256,1])];
end
reconstructed_test_images_rewarpped=double(reconstructed_test_images_rewarpped);

display_faces(reconstructed_test_images_rewarpped,mean_warpped_image_vector);

end
