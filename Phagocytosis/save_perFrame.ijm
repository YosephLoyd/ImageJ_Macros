Dialog.create("Size");
Dialog.addString("z slices:", "");
Dialog.show();
i=Dialog.getString();
run("Stack to Images");
for(n=1;n<=i;n+=1) {
	number=n-1;
	path= "C:/Users/loydy/Downloads/TrogocytosisTraining/20260312_wt_004_z" +number+"_masks.tif";
	close;
	save(path);
}