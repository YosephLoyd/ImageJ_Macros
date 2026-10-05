//Batch folder results - put into subfolders to process no more than 80 files long-yml

ipath = "C:\\Users\\loydy\\Collabs_images\\Phagocytosis_TP\\Phg_eff\\20250904_PhgEff_WT_B1_5,15,30min_20x\\c4";
ifpath = getFileList(ipath);
rpath = "C:\\Users\\loydy\\Collabs_images\\Phagocytosis_TP\\Phg_eff\\Analysis_YML\\20250904_ROIs\\c4";
rfpath = getFileList(rpath);
sFolder = "C:\\Users\\loydy\\Collabs_images\\Phagocytosis_TP\\Phg_eff\\Analysis_YML\\20250904_ImgMeasurements\\";

for(i=0;i<(rpath.length);i++) {
	
	open(ipath+"\\"+ifpath[i]);
	roiManager("Open", rpath+"\\"+rfpath[i]);
	selectImage(ifpath[i]);
	roiManager("multi-measure measure_all");
	
	
	saveAs("Results", sFolder+ifpath[i].substring(0, ifpath[i].length - 4)+"_Image_Results.csv");
	roiManager("Save", sFolder+rfpath[i].substring(0, rfpath[i].length - 4)+"_2_RoiSet.zip");
	roiManager("Deselect");
	roiManager("Delete");
	run("Close");
	run("Close");

}