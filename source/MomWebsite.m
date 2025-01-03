function MomWebsite
    clc
    
    %% imports tidbits
    % INSTRUCTIONS:
    % export google drive and add to the folder drvie_export
    fileloc='C:\Users\lukes\Documents\Github\MomWebsite\';

    [Image,Title,Date,Dimensions,Price,Display,Feature,Tags] = importfile([fileloc,'drive_export\Maria Photos.xlsx']);
    [Description,Awards] = importabout([fileloc,'drive_export\Maria Photos.xlsx']);

    about_1=fileread([fileloc,'source\about_1.txt']);
    about_2=fileread([fileloc,'source\about_2.txt']);
    about_3=fileread([fileloc,'source\about_3.txt']);
    
    slideshow_1=fileread([fileloc,'source\fullscreen_1.txt']);
    slideshow_2=fileread([fileloc,'source\fullscreen_2.txt']);
    slideshow_filler=fileread([fileloc,'source\fullscreen_filler.txt']);
    
    portfolio_1a=fileread([fileloc,'source\portfolio_1a.txt']);
    portfolio_1b=fileread([fileloc,'source\portfolio_1b.txt']);
    portfolio_2a=fileread([fileloc,'source\portfolio_2a.txt']);
    portfolio_2b=fileread([fileloc,'source\portfolio_2b.txt']);
    portfolio_filler=fileread([fileloc,'source\portfolio_filler.txt']);
    portfolio_1filler=fileread([fileloc,'source\portfolio_1filler.txt']);
    portfolio_2filler=fileread([fileloc,'source\portfolio_2filler.txt']);
    
    portfolio_file=[fileloc,'index.html'];
    slideshow_file=[fileloc,'fullscreen.html'];
    about_file=[fileloc,'about.html'];
    
    %converts display & feature to binary
    Displ = Display == 'Yes';
    Feat = Feature == 'Yes';
    disp('Files Loaded')
    %% creates images
    for i = [2:length(Image)]
%         if (Image(i) == "")
%         else
            if exist(fullfile(fileloc,'img\portfolio\',char(Image(i))))
                disp([i,Image(i),'Already Loaded'])
            else
                disp([i,Image(i),'Loading...'])
                img_src=fullfile(fileloc,'drive_export\Maria Photo Upload (File responses)\Select the photo to be uploaded. (File responses)\',char(Image(i)))
                img_full=imread(img_src);
                [h,w]=size(img_full);
            
                img_scaled=imresize(img_full,300/h);
                imwrite(img_scaled,fullfile(fileloc,'img\thumbnails\',char(Image(i))));
                copyfile(img_src,fullfile(fileloc,'img\portfolio\',char(Image(i))));
            end
%         end
    end
    disp('Images Copied')
    %% creates portfolio file
    fid = fopen(portfolio_file,'w');
    fprintf(fid, '%s', portfolio_1a);
    fclose(fid);
    Tags=erase(Tags,',');
    U_tags=unique(split(strjoin(Tags(2:end))));
    
    fid = fopen(portfolio_file,'a');
    
    for i = [3:length(U_tags)]
    	data=strrep(portfolio_1filler,'[tag]',U_tags(i));
        fprintf(fid, '%s', data);
    end
    
    fprintf(fid, '%s', portfolio_1b);
    
    for i = [1:length(Image)]
        if Displ(i)
            data=strrep(portfolio_filler,'[num]',Image(i));
            data=strrep(data,'[title]',Title(i));
            data=strrep(data,'[tags]',Tags(i));
            data=strrep(data,'[size]',strrep(Dimensions(i),'"','&#8243'));
            fprintf(fid, '%s', data);
        end
    end
        
    fprintf(fid, '%s', portfolio_2a);
    
    for i = [3:length(U_tags)]
    	data=strrep(portfolio_2filler,'[tag]',U_tags(i));
        fprintf(fid, '%s', data);
    end
    
    fprintf(fid, '%s', portfolio_2b);
    
    fclose(fid);
    disp('Portfolio Created')
    %% creates slideshow file
    fid = fopen(slideshow_file,'w');
    fprintf(fid, '%s', slideshow_1);
    fclose(fid);
    
    fid = fopen(slideshow_file,'a');
    for i = [1:length(Image)]
        if Feat(i)
            data=strrep(slideshow_filler,'[num]',Image(i));
            fprintf(fid, '%s', data);
        end
    end
        
    fprintf(fid, '%s', slideshow_2);
    fclose(fid);
    disp('Slideshow Created')
    
     %% creates about file
%     fid = fopen(about_file,'w');
%     fprintf(fid, '%s', about_1);
%     fclose(fid);
%     
%     fid = fopen(about_file,'a');
%     for i = [2:length(Description)]
% %         if Description(i)==""
% %         else
%             disp([i,Description(i)])
%             fprintf(fid, '%s', '<p>');
%             fprintf(fid, '%s', Description(i));
%             fprintf(fid, '%s', '</p>');
% %         end
%     end
%     fprintf(fid, '%s', about_2);
%     
%     for i = [2:length(Awards)]
% %         if Awards(i)==""
% %         else
%             disp([i,Awards(i)])
%             fprintf(fid, '%s', '<li>');
%             fprintf(fid, '%s', Awards(i));
%             fprintf(fid, '%s', '</li>');
% %         end
%     end
%     fprintf(fid, '%s', about_3);
% 
%     fclose(fid);
%     disp('Done')
end

function [Selectthephototobeuploaded,Title,DatePainted,DimensionsWxD,Price,DisplayinPortfolio,FeatureinSlideshow,Tags] = importfile(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet
%   [Selectthephototobeuploaded,Title,DatePainted,DimensionsWxD,Price,DisplayinPortfolio,FeatureinSlideshow,Tags]
%   = IMPORTFILE(FILE) reads data from the first worksheet in the Microsoft
%   Excel spreadsheet file named FILE and returns the data as column
%   vectors.
%
%   [Selectthephototobeuploaded,Title,DatePainted,DimensionsWxD,Price,DisplayinPortfolio,FeatureinSlideshow,Tags]
%   = IMPORTFILE(FILE,SHEET) reads from the specified worksheet.
%
%   [Selectthephototobeuploaded,Title,DatePainted,DimensionsWxD,Price,DisplayinPortfolio,FeatureinSlideshow,Tags]
%   = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW) reads from the specified
%   worksheet for the specified row interval(s). Specify STARTROW and
%   ENDROW as a pair of scalars or vectors of matching size for
%   dis-contiguous row intervals. To read to the end of the file specify an
%   ENDROW of inf.%
% Example:
%   [Selectthephototobeuploaded,Title,DatePainted,DimensionsWxD,Price,DisplayinPortfolio,FeatureinSlideshow,Tags] = importfile('Maria Photos.xlsx','Form Responses 1',1,3);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2023/02/07 14:27:49

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 1;
    endRow = 6000;
end

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, sprintf('B%d:I%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    [~, ~, tmpRawBlock] = xlsread(workbookFile, sheetName, sprintf('B%d:I%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
end
stringVectors = string(raw(:,[1,2,3,4,5,6,7,8]));
stringVectors(ismissing(stringVectors)) = '';

%% Allocate imported array to column variable names
Selectthephototobeuploaded = stringVectors(:,1);
Title = stringVectors(:,2);
DatePainted = stringVectors(:,3);
DimensionsWxD = stringVectors(:,4);
Price = stringVectors(:,5);
DisplayinPortfolio = stringVectors(:,6);
FeatureinSlideshow = stringVectors(:,7);
Tags = stringVectors(:,8);

end

function [Description,Awards] = importabout(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet
%   [Description,Awards] = IMPORTFILE(FILE) reads data from the first
%   worksheet in the Microsoft Excel spreadsheet file named FILE and
%   returns the data as column vectors.
%
%   [Description,Awards] = IMPORTFILE(FILE,SHEET) reads from the specified
%   worksheet.
%
%   [Description,Awards] = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW) reads
%   from the specified worksheet for the specified row interval(s). Specify
%   STARTROW and ENDROW as a pair of scalars or vectors of matching size
%   for dis-contiguous row intervals. To read to the end of the file
%   specify an ENDROW of inf.%
% Example:
%   [Description,Awards] = importfile('Maria Photos.xlsx','About',1,6);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2023/02/07 14:31:41

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 2;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 1;
    endRow = 50;
end

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, sprintf('A%d:B%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    [~, ~, tmpRawBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:B%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
end
stringVectors = string(raw(:,[1,2]));
stringVectors(ismissing(stringVectors)) = '';

%% Allocate imported array to column variable names
Description = stringVectors(:,1);
Awards = stringVectors(:,2);

end