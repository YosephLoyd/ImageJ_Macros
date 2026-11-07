//Author: YML
//Purpose: This is a short macro to take the ROI from an Nis Elements imaging
//session and convert it into a edge mask of the ROI. From this it is then duplicated X
//times for using as a overlay for videos.
//

//Talk ot me science person
Dialog.create("How many images in final stack:");
Dialog.addNumber("How many images in final stack:", 0);
Dialog.show();
TimePoints = Dialog.getNumber();

selectImage(File.name);

run("Find Edges");
run("Convolve...", "text1=[1 1 1 1 1 \n1 1 1 1 1 \n1 1 1 1 1 \n1 1 1 1 1 \n1 1 1 1 1\n]");

for (i=0; i<(TimePoints-1); i++){
	
	run("Duplicate...","title=[ ]");

}

run("Images to Stack", " ");