%random number stuff

X = randi(1000,100);

for i = 1:length(X)
    X(i) = mod(X(i),2);
    %disp(num2str(X(i)));
end
   

%str list
Y = [100];
for i = 1:size(X)
    if(X(i) == 1)
        Y(i) = 'a';
    else
        Y(i) = 'b';
    end
end

%fileIO

file = fopen("example.txt",'wt');
for i = 1:size(X)
    fprintf(file,num2str(X(i)));
end


fclose(file);


% data format
% name of text file = participant number
% inside txt file: 
% objectnumber/randomizationindicator/LorR~same~...~
% ex: 34/0/1~24/0/0~56/1/1~...

% number of files in folder
folder = dir("UserDataPrac");
disp(length(folder));
% note: substract 3 for unseen dir elements

%create new txt file 
filer = fopen("UserDataPrac/" + num2str(length(folder) - 2), 'wt');
fprintf(filer, "1/1/1~1/1/1~...");
fclose(filer);
newFolder = [length(folder)];

for i = 1: length(folder)
    %if (folder(1 , i) == ".DS_Store")
     %   folder(i) = [];
    %end
end

%folder doesnt actually need to be read in due to numbered nature of files

for i = 1:length(folder)
    disp(folder(i));
end



