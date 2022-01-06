k = 4;
%creates a table from the provided dataset with specified delimeter
f = readtable('iris.csv', 'Delimiter' , ',' , 'ReadVariableNames', false);
% creates another table by excluding the last column which is the class
% label columnn
f1 = f(  : , 1:size(f,2)-1);
%table2array function converts the table to a array
x = table2array(f1);
f2 = f(:,size(f,2) );%taking the labeled column
y = table2array(f2);
u = unique(y);          %array of unique class names
z = size(x,1);          %no of tuples in data
m = size(u,1);          %no of classes
p = zeros(z,1);         

for i = 1:z            %convert the class labels to integers starting from 1
   for j = 1:m
       if isa(y, 'numeric')
           if y(i)==u(j)

               p(i) = j;
           end
       else
           if strcmp(y(i),u(j))

               p(i) = j;
           end
       end
   end

end
yy = y;
y = p;


idx=randperm(size(x,1));    %make random array of range 1 to number of tuples with no repitition
test_ratio = 0.4;
test_size=round(size(x,1)*test_ratio);

testset=x(idx(1:test_size),:);     %making test train split
trainset=x(idx(test_size+1:end),:);


testlabel = y(idx(1:test_size),:);
trainlabel = y(idx(test_size+1:end),:);






z = size(trainset,1);   %trainset size

count = zeros(m,1);          %finding number of tuples of each class in the train set
for i = 1:z
    count(trainlabel(i)) = count(trainlabel(i)) + 1;
end
[mm, max_count_class] = max(count); %max_count_class stores number of the class with max tuples


%testset = [4 2 5 1];    %to predict new data

predict = zeros( size(testset,1) ,1); 



for j = 1: size(testset,1)   %runs for all testset example
    all_distances = zeros( z ,1);
    class_count = zeros(m,1);
    for i = 1:z
        all_distances(i,1) = distance( trainset(i,:), testset(j, : )  );
    end
    all_distances_sorted = sort(all_distances);
    for i = 1:k
        minim = all_distances_sorted(i);
        index = find(all_distances == minim);
        class_count(trainlabel(index(1))) = class_count(trainlabel(index(1))) + 1;
    end
    [mm,predict(j)] = max(class_count);
    max_indices = find(class_count == mm);
    if size(max_indices,1) > 1
        predict(j) = max_count_class;
    end
end

%%%%%%%%      find accuracy
count1 = 0;
for i = 1: size(testset,1)
    if predict(i) == testlabel(i)
        count1 = count1 + 1;
    end
end

accuracy = 100*count1/size(testlabel,1)

%%%%%%%

%disp(u(predict))