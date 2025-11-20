//Date: 10/28/2024
//Author: Yoseph M. Loyd
//Purpose: generate mask of fine features (i.e. punta/ podosomes) in cell cultures, 
//assumes that you are inputting 2D data. This function will allow you to input the channel
//(assumed an actin probe is used) to use to identify the structure. It then generates 
//a masked image the global ROI, all independent ROIs, and subsequent measurements 
//(defaulted as your session defaults).

// Input information used in saving
Dialog.create("Which Channel to mask:");
Dialog.addNumber("Channel", 1);
Dialog.addString("Image info: Data-Dataset","YYYYMMDD-data");
Dialog.show();
Data= Dialog.getString();
channel=Dialog.getNumber();

//Generate file path for saving (removed for MacOs Issue)
//Dialog.create("Name that dataset");
//Dialog.addDirectory("File path to save to:","");
//Dialog.show();
//direct2u = Dialog.getString();

//Generating the mask
run("Duplicate...", "duplicate frames=1");
rename("image_Channels");
run("Duplicate...", "duplicate channels="+channel);
rename(Data+"_Actin_Mask");
////Conversion from 16 bit to binary mask
setMinAndMax(0,getValue("Max")*1.1)
setOption("ScaleConversions", true);
run("8-bit");
run("Auto Local Threshold", "method=Bernsen radius=10 parameter_1=0 parameter_2=0 white");
setOption("BlackBackground", false);
run("Convert to Mask");
////Cleaning noise
run("Erode");
run("Dilate");

//Geting the ROIs
run("Create Selection");
run("ROI Manager...");

roiManager("Add");
roiManager("Select", 0);
roiManager("Rename", "All_ROIs");
roiManager("Split");

selectImage("image_Channels");
roiManager("Show All");

//Commented out the auto-saving feature
//roiManager("save selected", direct2u+Data + "_ROI_All.zip")
//Auto measuring features
roiManager("deselect all");
roiManager("Show none");
roiManager("multi-measure measure_all append");
//saveAs("Results", direct2u+Data+"Results.csv");

//selectImage("Actin_Mask");
//saveAs("Tiff", direct2u+Data+".tif")

