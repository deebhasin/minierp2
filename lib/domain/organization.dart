class Organization {

	int id;
	String name;
	String contact;
	String address;
	int pin;
	String city;
	String state;
	// String stateCode;
	String gst;
	String logo;
	// int creditPeriod;  // NUMBER OF DAYS
	// bool active;
	Organization({
		required this.id,
		required this.name,
		this.contact = "",
		this.address = "",
		this.pin = 0,
		this.city = "",
		this.state = "",
		this.gst = "",
		this.logo=""
	});

}