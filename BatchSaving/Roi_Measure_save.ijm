//User should validate each roiset before saving

Dialog.create("labeling data");
Dialog.addString("Image title","pooping");
Dialog.show();
title = Dialog.getString();

image= title+"_bead_exclusions_magenta_igg_green_masks"
roiManager("Deselect");
roiManager("Save", "C:\\Users\\yosep\\Desktop\\20260724_PhgEff_Wt_B1_5,15,30min_20x\\yml analysis\\"+title+"_RoiSet.zip");
selectImage(image+".tif");

roiManager("multi-measure measure_all");
saveAs("Results", "C:\\Users\\yosep\\Desktop\\20260724_PhgEff_Wt_B1_5,15,30min_20x\\yml analysis\\"+title+"_Results.csv");

//run("Close all");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
roiManager("Deselect");
roiManager("Delete");