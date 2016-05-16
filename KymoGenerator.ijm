//Fiji_KymoCalcium_GCaMP
//v_0_0
//2016 Jan 08 Jeff Bouffard 

//Generates kymograph for a single movie
//Input: Movie processed by Fiji_Process_GCaMP.  Currently only _A
//Output: Kymographs in both directions, average, max, and sum
//Output: Wide line plot profile over region of interest - currently whole frame

//-----------------------------------------------------------------------------------------------------------
//In this macro frames are slices because Fiji seems to want to treat frames as slices in 3D movies
//I successfully corrected it in Fiji_Process_GCaMP_1_1, but it is detrimental because there isn't a command to get the frame number

//----------------------------------------------------------------------------------------
//Clearing Fiji of all open images and windows
waitForUser("SAVE ANY FILES YOU WANT TO KEEP!!!","All images and windows open in Fiji will be closed when you press OK! \nSave any images or files you wish to keep.");

//next line lifted from http://rsb.info.nih.gov/ij/macros/Close_All_Windows.txt
while (nImages>0) {selectImage(nImages); close();}

//next line lifted from http://imagej.1557.x6.nabble.com/Result-window-in-macro-td3698804.html
if (isOpen("Results")) {selectWindow("Results"); run("Close");}

if(isOpen("ROI Manager")){selectWindow("ROI Manager");run("Close");}
if(isOpen("Log")){selectWindow("Log");run("Close");}

//----------------------------------------------------------------------------------------
//Opening and gathering information from movie file
filepath=File.openDialog("Select a File");
	//print(filepath); //if you want to see the filepath in log window
open(filepath);

title = getTitle();
titleID = getImageID();
Stack.getDimensions(width,height,channel,slice,frame);

SplitString = split(title,"."); 
	//print(SplitString[0]); //if you want to see SplitString in log window

SplitFilepath = split(filepath,"/");
Array.print(SplitFilepath);

Directory="/"+SplitFilepath[0]+"/"+SplitFilepath[1]+"/"+SplitFilepath[2]+"/"+SplitFilepath[3]+"/"+SplitFilepath[4]+"/";
print(Directory); //if you want to see Directory in log window

//----------------------------------------------------------------------------------------
//Defining Kymograph folder
KymographDirectory = Directory+"Kymographs"+"/"; 
print("KymoD: " + KymographDirectory);
	//If a folder for kymograph data doesn't exist, then it is created.
if (File.isDirectory(KymographDirectory)!=1) {File.makeDirectory(KymographDirectory)};

//Defining KymoCalcium folder
KymoCalciumDirectory = Directory+"KymoCalcium"+"/";
	//If KymoCalcium folder doesn't exist then it is created.
if (File.isDirectory(KymoCalciumDirectory)!=1) {File.makeDirectory(KymoCalciumDirectory);};

//----------------------------------------------------------------------------------------
//Generating Average Kymograph via Reslice and Z-project and saving 

//Kymograph over each x column 
run("Reslice [/]...", "output=1.000 start=Top avoid");
Resliced=getImageID();

	//Average
run("Z Project...", "projection=[Average Intensity]");
AvgKymoX=getImageID();
NewTitle_AvgKymoX = SplitString[0]+"_AvgKymoX";
print("AvgKymo: " + NewTitle_AvgKymoX); 
saveAs("Tiff",KymographDirectory+NewTitle_AvgKymoX);


//Acquiring calcium signal from kymograph via wide line profile
run("Flip Vertically");
setLineWidth(width);
midWidth=((width)/2);
makeLine(midWidth, 0, midWidth, slice, width);
profile=getProfile();
if (File.exists(KymoCalciumDirectory+NewTitle_AvgKymoX+".dat")==1){
	showMessageWithCancel("File will be overwritten.  Press OK to continue and overwrite or cancel to exit macro");
	File.delete(KymoCalciumDirectory+NewTitle_AvgKymoX+".dat");
}
AvgKymoX_Calcium = File.open(KymoCalciumDirectory+NewTitle_AvgKymoX+".dat");
for (i=0; i<profile.length; i++){print(AvgKymoX_Calcium, profile[i]+" ");};
File.close(AvgKymoX_Calcium);
selectImage(AvgKymoX); close();

	//Maximum
selectImage(Resliced);
run("Z Project...", "projection=[Max Intensity]");
MaxKymoX=getImageID();
NewTitle_MaxKymoX = SplitString[0]+"_MaxKymoX";
saveAs("Tiff",KymographDirectory+NewTitle_MaxKymoX);

//Acquiring calcium signal from kymograph via wide line profile
run("Flip Vertically");
setLineWidth(width);
midWidth=((width)/2);
makeLine(midWidth, 0, midWidth, slice, width);
profile=getProfile();
if (File.exists(KymoCalciumDirectory+NewTitle_MaxKymoX+".dat")==1){
	showMessageWithCancel("File will be overwritten.  Press OK to continue and overwrite or cancel to exit macro");
	File.delete(KymoCalciumDirectory+NewTitle_MaxKymoX+".dat");
}
MaxKymoX_Calcium = File.open(KymoCalciumDirectory+NewTitle_MaxKymoX+".dat");
for (i=0; i<profile.length; i++){print(MaxKymoX_Calcium, profile[i]+" ");};
File.close(MaxKymoX_Calcium);
selectImage(MaxKymoX); close();

	//Minimum
selectImage(Resliced);
run("Z Project...", "projection=[Min Intensity]");
MinKymoX=getImageID();
NewTitle_MinKymoX = SplitString[0]+"_MinKymoX";
saveAs("Tiff",KymographDirectory+NewTitle_MinKymoX);

//Acquiring calcium signal from kymograph via wide line profile
run("Flip Vertically");
setLineWidth(width);
midWidth=((width)/2);
makeLine(midWidth, 0, midWidth, slice, width);
profile=getProfile();
if (File.exists(KymoCalciumDirectory+NewTitle_MinKymoX+".dat")==1){
	showMessageWithCancel("File will be overwritten.  Press OK to continue and overwrite or cancel to exit macro");
	File.delete(KymoCalciumDirectory+NewTitle_MinKymoX+".dat");
}
MinKymoX_Calcium = File.open(KymoCalciumDirectory+NewTitle_MinKymoX+".dat");
for (i=0; i<profile.length; i++){print(MinKymoX_Calcium, profile[i]+" ");};
File.close(MinKymoX_Calcium);
selectImage(MinKymoX); close();

	//Sum
selectImage(Resliced);
run("Z Project...", "projection=[Sum Slices]");
SumKymoX=getImageID();
NewTitle_SumKymoX = SplitString[0]+"_SumKymoX";
run("8-bit");
run("Fire");
saveAs("Tiff",KymographDirectory+NewTitle_SumKymoX);

//Acquiring calcium signal from kymograph via wide line profile
run("Flip Vertically");
setLineWidth(width);
midWidth=((width)/2);
makeLine(midWidth, 0, midWidth, slice, width);
profile=getProfile();
if (File.exists(KymoCalciumDirectory+NewTitle_SumKymoX+".dat")==1){
	showMessageWithCancel("File will be overwritten.  Press OK to continue and overwrite or cancel to exit macro");
	File.delete(KymoCalciumDirectory+NewTitle_SumKymoX+".dat");
}
SumKymoX_Calcium = File.open(KymoCalciumDirectory+NewTitle_SumKymoX+".dat");
for (i=0; i<profile.length; i++){print(SumKymoX_Calcium, profile[i]+" ");};
File.close(SumKymoX_Calcium);
selectImage(SumKymoX); close();

selectImage(Resliced);close();

//---------------------------------------------------------------------------------
//Kymograph over each y row 
run("Reslice [/]...", "output=1.000 start=Left flip avoid");
Resliced=getImageID();

	//Average
run("Z Project...", "projection=[Average Intensity]");
AvgKymoY=getImageID();
NewTitle_AvgKymoY = SplitString[0]+"_AvgKymoY";

//Acquiring calcium signal from kymograph via wide line profile
run("Flip Vertically");
setLineWidth(width);
midWidth=((width)/2);
makeLine(midWidth, 0, midWidth, slice, width);
profile=getProfile();
if (File.exists(KymoCalciumDirectory+NewTitle_AvgKymoY+".dat")==1){
	showMessageWithCancel("File will be overwritten.  Press OK to continue and overwrite or cancel to exit macro");
	File.delete(KymoCalciumDirectory+NewTitle_AvgKymoY+".dat");
}
AvgKymoY_Calcium = File.open(KymoCalciumDirectory+NewTitle_AvgKymoY+".dat");
for (i=0; i<profile.length; i++){print(AvgKymoY_Calcium, profile[i]+" ");};
File.close(AvgKymoY_Calcium);

selectImage(AvgKymoY); 
run("Flip Vertically"); 
run("Rotate 90 Degrees Right");
saveAs("Tiff",KymographDirectory+NewTitle_AvgKymoY);
close();


	//Maximum
selectImage(Resliced);
run("Z Project...", "projection=[Max Intensity]");
MaxKymoY=getImageID();
NewTitle_MaxKymoY = SplitString[0]+"_MaxKymoY";

//Acquiring calcium signal from kymograph via wide line profile
run("Flip Vertically");
setLineWidth(width);
midWidth=((width)/2);
makeLine(midWidth, 0, midWidth, slice, width);
profile=getProfile();
if (File.exists(KymoCalciumDirectory+NewTitle_MaxKymoY+".dat")==1){
	showMessageWithCancel("File will be overwritten.  Press OK to continue and overwrite or cancel to exit macro");
	File.delete(KymoCalciumDirectory+NewTitle_MaxKymoY+".dat");
}

MaxKymoY_Calcium = File.open(KymoCalciumDirectory+NewTitle_MaxKymoY+".dat");
for (i=0; i<profile.length; i++){print(MaxKymoY_Calcium, profile[i]+" ");};
File.close(MaxKymoY_Calcium);

selectImage(MaxKymoY); 
run("Flip Vertically"); 
run("Rotate 90 Degrees Right");
saveAs("Tiff",KymographDirectory+NewTitle_MaxKymoY);
close();

	//Minimum
selectImage(Resliced);
run("Z Project...", "projection=[Min Intensity]");
MinKymoY=getImageID();
NewTitle_MinKymoY = SplitString[0]+"_MinKymoY";

//Acquiring calcium signal from kymograph via wide line profile
run("Flip Vertically");
setLineWidth(width);
midWidth=((width)/2);
makeLine(midWidth, 0, midWidth, slice, width);
profile=getProfile();
if (File.exists(KymoCalciumDirectory+NewTitle_MinKymoY+".dat")==1){
	showMessageWithCancel("File will be overwritten.  Press OK to continue and overwrite or cancel to exit macro");
	File.delete(KymoCalciumDirectory+NewTitle_MinKymoY+".dat");
}
MinKymoY_Calcium = File.open(KymoCalciumDirectory+NewTitle_MinKymoY+".dat");
for (i=0; i<profile.length; i++){print(MinKymoY_Calcium, profile[i]+" ");};
File.close(MinKymoY_Calcium);

selectImage(MinKymoY); 
run("Flip Vertically"); 
run("Rotate 90 Degrees Right");
saveAs("Tiff",KymographDirectory+NewTitle_MinKymoY);
close();

	//Sum
selectImage(Resliced);
run("Z Project...", "projection=[Sum Slices]");
SumKymoY=getImageID();
NewTitle_SumKymoY = SplitString[0]+"_SumKymoY";
run("8-bit");
run("Fire");

//Acquiring calcium signal from kymograph via wide line profile
run("Flip Vertically");
setLineWidth(width);
midWidth=((width)/2);
makeLine(midWidth, 0, midWidth, slice, width);
profile=getProfile();
if (File.exists(KymoCalciumDirectory+NewTitle_SumKymoY+".dat")==1){
	showMessageWithCancel("File will be overwritten.  Press OK to continue and overwrite or cancel to exit macro");
	File.delete(KymoCalciumDirectory+NewTitle_SumKymoY+".dat");
}
SumKymoY_Calcium = File.open(KymoCalciumDirectory+NewTitle_SumKymoY+".dat");
for (i=0; i<profile.length; i++){print(SumKymoY_Calcium, profile[i]+" ");};
File.close(SumKymoY_Calcium);

selectImage(SumKymoY);
run("Flip Vertically"); 
run("Rotate 90 Degrees Right");
saveAs("Tiff",KymographDirectory+NewTitle_SumKymoY);
close();

selectImage(Resliced);close();
