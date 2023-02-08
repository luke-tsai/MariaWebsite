function MomWebsite
    clc
    
    %% imports tidbits
    fileloc='C:\Users\ltsai\Documents\Google Drive\Maria Painting fulls\Website\';
    
    [Image,Dimensions,Title,Date,Price,Display,Feature,Tag1,Tag2,Tag3,Tag4,A,B,C,D] = importfile([fileloc,'Website Script\PaintingData.xlsx']);
    
    header=fileread([fileloc,'Website Script\src\Header.txt']);
    p1header=fileread([fileloc,'\Website Script\src\p1_Header2.txt']);
    p1body=fileread([fileloc,'Website Script\src\p1_Body2.txt']);
    p1footer=fileread([fileloc,'Website Script\src\p1_footer.txt']);
    
    p2header=fileread([fileloc,'Website Script\src\p2_Header.txt']);
    p2body=fileread([fileloc,'Website Script\src\p2_Body.txt']);
    pfooter=fileread([fileloc,'Website Script\src\p_Footer.txt']);
    
    iheader=fileread([fileloc,'Website Script\src\i_Header.txt']);
    ibody=fileread([fileloc,'Website Script\src\i_Body.txt']);
    ibody2=fileread([fileloc,'Website Script\src\i_Body2.txt']);
    ifooter1=fileread([fileloc,'Website Script\src\i_Footer1.txt']);
    ifooter2=fileread([fileloc,'Website Script\src\i_Footer2.txt']);
    
    footer=fileread([fileloc,'Website Script\src\Footer.txt']);
    p1file=[fileloc,'Website\portfolio.html'];
%     p2file=[fileloc,'Website\portfolio-1.html'];
    ifile=[fileloc,'Website\index.html'];
    
    bio=fileread([fileloc,'Website Script\Biography.txt']);
    
    %converts display & feature to binary
    Displ = Display == 'Yes';
    Feat = Feature == 'Yes';
    Tags=join([Tag1,Tag2,Tag3,Tag4]);
    
    %% creates portfolio 1 file
    fid = fopen(p1file,'w');
    fprintf(fid, '%s', header);
    fclose(fid);
    
    fid = fopen(p1file,'a');
    fprintf(fid, '%s', p1header);
    for i = [1:max(Image)]
        if Displ(i)
            data=strrep(p1body,'[num]',num2str(Image(i)));
            data=strrep(data,'[title]',Title(i));
            data=strrep(data,'[tags]',Tags(i));
            data=strrep(data,'[size]',strrep(Dimensions(i),'"','&#8243'));
            fprintf(fid, '%s', data);
        end
    end
        
    fprintf(fid, '%s', p1footer);
    fclose(fid);
    
%     %% creates portfolio 2 file
% 
%     fid = fopen(p2file,'w');
%     fprintf(fid, '%s', header);
%     fclose(fid);
%     
%     fid = fopen(p2file,'a');
%     fprintf(fid, '%s', p2header);
%     for i = [1:max(Image)]
%         if Displ(i)
%             data=strrep(p2body,'[num]',num2str(Image(i)));
%             data=strrep(data,'[tags]',Tags(i));
%             data=strrep(data,'[title]',Title(i));
%             data=strrep(data,'[subtitle]',Dimensions(i));
%             fprintf(fid, '%s', data);
%         end
%     end
%         
%     fprintf(fid, '%s', pfooter);
%     fprintf(fid, '%s', footer);
%     fclose(fid);
%     
    %% creates index file

    fid = fopen(ifile,'w');
    fprintf(fid, '%s', header);
    fclose(fid);
    
    fid = fopen(ifile,'a');
    fprintf(fid, '%s', iheader);
    
    featured=find(Feat);
    featured=featured(randperm(length(featured)));
    
    for i = 1:3
        for j=1:7
            info=imfinfo([fileloc,'Website\img\portfolio\tn_',num2str(featured((i-1)*7+j)),'.jpg']);
            data=strrep(ibody,'[num]',num2str(Image(featured((i-1)*7+j))));
            data=strrep(data,'[title]',Title(featured((i-1)*7+j)));
            data=strrep(data,'[size]',strrep(Dimensions(featured((i-1)*7+j)),'"','&#8243'));
            data=strrep(data,'[wid]',num2str(info.Width));
            fprintf(fid, '%s', data);
        end
        if ismember(i,[1,2])
            fprintf(fid, '%s', ibody2);
        end
    end
    
    biography=char(strsplit(bio,{char(13),char(10)},'CollapseDelimiters',true));
    %%close out
    fprintf(fid, '%s', ifooter1);
    for i=1:size(biography,1)
        fprintf(fid, '%s', '<p>');
        fprintf(fid, '%s', biography(i,:));
        fprintf(fid, '%s', '</p>');
    end
    fprintf(fid, '%s', ifooter2);
    fprintf(fid, '%s', footer);
    fclose(fid);
    
    disp("Done")
end


function [Image,Dimensions,Title,Date,Price,Display,Feature,Tag1,Tag2,Tag3,Tag4,A,B,C,D] = importfile(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet
%   [Image,Dimensions,Title,Date,Price,Display,Feature23selectedof21,Tag1,Tag2,Tag3,Tag4,A,B,C,D]
%   = IMPORTFILE(FILE) reads data from the first worksheet in the Microsoft
%   Excel spreadsheet file named FILE and returns the data as column
%   vectors.
%
%   [Image,Dimensions,Title,Date,Price,Display,Feature23selectedof21,Tag1,Tag2,Tag3,Tag4,A,B,C,D]
%   = IMPORTFILE(FILE,SHEET) reads from the specified worksheet.
%
%   [Image,Dimensions,Title,Date,Price,Display,Feature23selectedof21,Tag1,Tag2,Tag3,Tag4,A,B,C,D]
%   = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW) reads from the specified
%   worksheet for the specified row interval(s). Specify STARTROW and
%   ENDROW as a pair of scalars or vectors of matching size for
%   dis-contiguous row intervals. To read to the end of the file specify an
%   ENDROW of inf.
%
%	Non-numeric cells are replaced with: NaN
%
% Example:
%   [Image,Dimensions,Title,Date,Price,Display,Feature23selectedof21,Tag1,Tag2,Tag3,Tag4,A,B,C,D] = importfile('PaintingData.xlsx','Sheet1',1,68);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2020/08/17 10:52:28

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 5000;
end

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, sprintf('A%d:O%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    [~, ~, tmpRawBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:O%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
stringVectors = string(raw(:,[2,3,5,6,7,8,9,10,11,12,13,14,15]));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[1,4]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
I = cellfun(@(x) ischar(x), raw);
raw(I) = {NaN};
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
Image = data(:,1);
Dimensions = stringVectors(:,1);
Title = stringVectors(:,2);
Date = data(:,2);
Price = stringVectors(:,3);
Display = categorical(stringVectors(:,4));
Feature = categorical(stringVectors(:,5));
Tag1 = stringVectors(:,6);
Tag2 = stringVectors(:,7);
Tag3 = stringVectors(:,8);
Tag4 = stringVectors(:,9);
A = stringVectors(:,10);
B = stringVectors(:,11);
C = stringVectors(:,12);
D = stringVectors(:,13);

end
