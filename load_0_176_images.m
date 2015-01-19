function [training_set_images,test_set_images] = load_0_176_images() %loads both the 150 training and the 27 test images as vectors each appended into matrices
listing=dir('face_data/face');
training_set_images=[];
test_set_images=[];
for i=0:149
    image_name=sprintf('face_data/face/%s',listing(5+i).name);
    single_image_matrix=imread(image_name);
    training_set_images=[training_set_images,single_image_matrix(:)];
end
for i=150:176
    image_name=sprintf('face_data/face/%s',listing(5+i).name);
    single_image_matrix=imread(image_name);
    test_set_images=[test_set_images,single_image_matrix(:)];
end
end

