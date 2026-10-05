// Authour: YML
// Date: 20260707S v002
// Def: pipeline for selected images cahnnels to output
// % union of two mask. Current implementation is for the body 
// of a bead and the second the mask of it's labeled exterior.

// Input information used for saving later saving

// data date and condtion
Dialog.create("labeling data");
Dialog.addString("Image info: Date_Dataset","YYYYMMDD-data");
Dialog.show();
title1= Dialog.getString();

// first mask
Dialog.create("Which Channel is the bead:");
Dialog.addNumber("Which Channel is the bead:", 2);
Dialog.show();
bod1=Dialog.getNumber();

// second mask
Dialog.create("Which Channel is the bead outside:");
Dialog.addNumber("Witch Channel is the bead outside:", 3);
Dialog.show();
bod2=Dialog.getNumber();

// making dups
run("Duplicate...", "title=bead "+"duplicate channels="+bod1+"-"+bod1);
selectImage(title1+".nd2");
run("Duplicate...", "title=igg "+"duplicate channels="+bod2+"-"+bod2);

// start the magic
selectImage("bead");
run("Duplicate...","title=bead_mask")
// let Sade cook
run("Smooth");
// Classic thresh
run("Auto Threshold", "method=MaxEntropy white");
//mask ops
run("Make Binary", "background=Light calculate");
run("Fill Holes");
run("Watershed");

// Igg not watershed. Channel is used in tandem to the bead mask that was watershed.
selectImage("igg");
run("Duplicate...","title=igg_mask")
// let Sade cook
run("Smooth");
// Classic thresh
run("Auto Threshold", "method=MaxEntropy white");
//mask ops20250212_RAWB1_003
run("Make Binary", "background=Light calculate");
run("Fill Holes");

//stack images
run("Merge Channels...", "c2=igg_mask c6=bead_mask create keep");
title2=title1+"_bead_magenta_igg_green_masks.tif"
rename(title2);
path= "C:\\Users\\loydy\\Collabs_images\\Phagocytosis_TP\\Phg_eff\\Analysis_YML\\"+title2;
save(path);

// These next steps are ment to point towards what the user should do next as
// ImageJ has a harder time watershedding several beads in triangle orientations.
// If it is needed manually seperate the beads in the masked data further otherwise
// continue to the next set of operations.

// simple size exclusion and ROI generation for beads
selectImage("bead_mask");
run("Analyze Particles...", "size=50-350 circularity=0.5-1.00 show=Masks exclude clear add");

selectImage(title2);

//Messy images will need rois to be trimmed by the user.
//roiManager("multi-measure measure_all");
//selectWindow("Results");
//saveAs("Results", "C:\\Users\\loydy\\Collabs_images\\Phagocytosis_TP\\Phg_eff\\Analysis_YML\\"+title1+"_Results.csv");
run("Close");

//Second stack with exclusions in bead channel
selectImage("Mask of bead_mask");
rename("bead_mask_exclusions");
run("Merge Channels...", "c2=igg_mask c6=bead_mask_exclusions create keep");
title3=title1+"_bead_exclusions_magenta_igg_green_masks.tif"
rename(title3);
path= "C:\\Users\\loydy\\Collabs_images\\Phagocytosis_TP\\Phg_eff\\Analysis_YML\\"+title3;
save(path);

//User should validate each roiset before saving
//roiManager("Save", "C:/Users/loydy/Collabs_images/Phagocytosis_TP/yml_analsis/"+title1+"_RoiSet.zip");
//run("Close")
//run("Close all")
