//Date: 2/4/2025
//Author: Yoseph M. Loyd
//Purpose: generate mask of gel degregation sites in fluorescent substrates, 
//assumes that you are inputting 3D data. This function will allow you to input the channel
//(assumed an actin probe is used) to use to identify the cell. It then generates 
//a masked image the global ROI, all independent ROIs, and subsequent measurements 
//(defaulted as your session defaults).

// Input information used in saving
Dialog.create("Which Channel is the gel:");
Dialog.addNumber("Which Channel is the gel:", 1);
//Dialog.addString("Image info: Data-Dataset","YYYYMMDD-data");
Dialog.show();
//Data= Dialog.getString();
gel=Dialog.getNumber();

Dialog.create("Which Channel is the cell:");
Dialog.addNumber("Witch Channel is the cell:", 2);
Dialog.show();
cell=Dialog.getNumber();


//Generate file path for saving
//Dialog.create("Name that dataset");
//Dialog.addDirectory("File path to save to:","");
//Dialog.show();
//direct2u = Dialog.getString();
run("Z Project...", "projection=[Max Intensity]");
rename("zMip")
//Generating the mask of gel
run("Duplicate...", "duplicate channels="+gel);
rename("Gel");
setMinAndMax(0,getValue("Max")*1.1)

////Conversion from 16 bit to binary mask
setOption("ScaleConversions", true);
run("8-bit");
run("Auto Local Threshold", "method=Sauvola radius=15 parameter_1=0 parameter_2=0 white");

setOption("BlackBackground", false);
run("Convert to Mask");
//inverting
run("Add...", "value=1");
run("Reciprocal");
run("Convert to Mask");

rename("Gel_Mask");

////Cleaning noise
run("Erode");
run("Dilate");

//Masking the cell body through actin stain
selectImage("zMip")
run("Duplicate...", "duplicate channels="+cell);
run("Auto Threshold", "method=Triangle white");
setOption("BlackBackground", false);
run("Despeckle");
run("Convert to Mask");
run("Fill Holes");
run("Erode");
run("Dilate");
rename("Cell_Mask");

run("Merge Channels...", "c2=Gel_Mask c6=Cell_Mask create keep ignore");