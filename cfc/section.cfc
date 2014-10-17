component{
	public section function init(){
		variables.sectiondescription = "";
		variables.shelflocation = "";
		return this;	
	}
	
	public void function setup(string sd, string sl){
		variables.sectiondescription = sd;
		variables.shelflocation = sl;
	}
	
	public string function test(){
		return variables.sectiondescription & variables.shelflocation; 
	}
}