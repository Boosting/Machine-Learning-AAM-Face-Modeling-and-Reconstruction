function [female_set_landmarks,male_set_landmarks] = load_male_female_landmarks_test()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
listing=dir('face_data/female_landmark_87');

female_set_landmarks=[];
for i=75:84
    image_name=sprintf('face_data/female_landmark_87/%s',listing(5+i).name);
    single_landmark_matrix=dlmread(image_name);
    female_set_landmarks=[female_set_landmarks,single_landmark_matrix(:)];

end
listing=dir('face_data/male_landmark_87');
male_set_landmarks=[];
for i=77:86
    image_name=sprintf('face_data/male_landmark_87/%s',listing(5+i).name);
    single_landmark_matrix=dlmread(image_name);
    size(single_landmark_matrix)
    male_set_landmarks=[male_set_landmarks,single_landmark_matrix(:)];
end


end

