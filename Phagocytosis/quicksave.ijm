// Author: YML
// Date: 20261005
// This macro is a short saving each roi measurement and then closing images from
// "Auto_masking_Beads_External_IgG" macro. 

Dialog.create("saving info");
Dialog.addString("Image info: Date_Dataset","YYYYMMDD-data");
Dialog.show();
title1= Dialog.getString();

roiManager("Deselect");
roiManager("Save", "C:/Users/loydy/Collabs_images/Phagocytosis_TP/Phg_eff/Analysis_YML/MaskedImages/"+title1+"_RoiSet.zip");

selectImage(title1+"_bead_exclusions_magenta_igg_green_masks.tif");
roiManager("multi-measure measure_all");
saveAs("Results", "C:/Users/loydy/Collabs_images/Phagocytosis_TP/Phg_eff/Analysis_YML/MaskedImages/"+title1+"_Results.csv");

roiManager("Deselect");
roiManager("Delete");

// When closing all images the close all could not be implemented correctly and so this
// was an easiy alternative.

run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");