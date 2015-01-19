function main_script_fisher()
%Fisher Faces

[female_set_images,male_set_images]=load_female_male_images();

%Calculate mean

female_set_mean = get_mean_image_vector(female_set_images);
male_set_mean = get_mean_image_vector(male_set_images);
total_image_set=[female_set_images male_set_images];

%Finding the SVD of the Total image matrix (Variables used as in PDF
%explantion)

mult_matrix = double(total_image_set') * double(total_image_set);
[u,l,v] = svd(mult_matrix);
[r,c] = size(u);
ce = double(total_image_set) * u;

%display_fisher_face(ce(:,1));
%Diplay the Fisher Face 
eigen_vectors=[];
for i=1:c
  eigen_vectors(:,i) =  u(:,i) /norm( u(:,i));
  a(:,i) =  (ce(:,i)/norm(ce(:,i))) .*sqrt(l(i,i));
end



%Computing the PDF document Equations-- 
y = a' * (female_set_mean - male_set_mean);
z = inv(l*l*eigen_vectors') * y;
w = double(total_image_set)*z;
display_fisher_face(w);
w0 = (w' * male_set_mean + w' * female_set_mean)./2;


%----------------------------------------------------------------------------
%Reading All TEST images - To Check Ficher Classification Error 

[female_set_images_test,male_set_images_test]=load_female_male_test_images();
x_fem=[];
x_male=[];
for i=1:10
  x_fem =[x_fem (w'*double(female_set_images_test(:,i))-w0)];
  x_male = [x_male (w' * double(male_set_images_test(:,i)) - w0)];
end
x_fem
x_male
no_fem_pos=0;
no_fem_neg=0;
no_male_pos=0;
no_male_neg=0;

for i=1:10
    if x_fem(i)>0
    no_fem_pos=no_fem_pos+1;
    else
    no_fem_neg=no_fem_neg+1;
    end
    
    if x_male(i)>0
    no_male_pos=no_male_pos+1;
    else
    no_male_neg=no_male_neg+1;
    end
end

figure;
pie([no_fem_pos,no_fem_neg]);
labels={'Correctly Classified at Female','Wrongly Classifies as Male'};
legend(labels,'Location','southoutside','Orientation','vertical');
title('Fisher Face -  Female Face Classification');


figure;
pie([no_male_pos,no_male_neg]);
labels={'Correctly Classified at Male','Wrongly Classifies as Female'};
legend(labels,'Location','southoutside','Orientation','vertical');
title('Fisher Face -  Male Face Classification');

%----------------------------------------------------------------------------



end

