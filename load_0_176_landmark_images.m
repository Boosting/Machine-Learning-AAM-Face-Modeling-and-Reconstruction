function [training_set_landmarks,test_set_landmarks] = load_0_176_landmark_images() %loads both the 150 training and the 27 test images as vectors each appended into matrices
listing=dir('face_data/landmark_87');
training_set_landmarks=[];
test_set_landmarks=[];
for i=0:149
    image_name=sprintf('face_data/landmark_87/%s',listing(5+i).name);
    single_landmark_matrix=dlmread(image_name);
    single_landmark_matrix=single_landmark_matrix(2:88,:);
    training_set_landmarks=[training_set_landmarks,single_landmark_matrix(:)];

end
for i=150:176
    image_name=sprintf('face_data/landmark_87/%s',listing(5+i).name);
    single_landmark_matrix=dlmread(image_name);
    single_landmark_matrix=single_landmark_matrix(2:88,:);
    test_set_landmarks=[test_set_landmarks,single_landmark_matrix(:)];
end

end

