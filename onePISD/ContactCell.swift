/**
* ContactCell
* The Cell that holds and displays the staff
* onePISD
*
* @author Enrico Borba
* Period: 2
* Date: 5/18/15
* Copyright (c) 2015 Enrico Borba. All rights reserved.
*/

import UIKit

class ContactCell: UITableViewCell {
	var faculty_entry: FacultyEntry?
	var background: UIView?
	var configured = false
	
	/**
	* Configures the cell for display
	* @param faculty_entry The faculty entry data.
	*/
	func configure(faculty_entry: FacultyEntry) {
		self.faculty_entry = faculty_entry
		var name = faculty_entry.firstName
		if faculty_entry.lastName.length() != 0 {
			name += " " + faculty_entry.lastName
		}
		self.textLabel?.text = name
		self.textLabel?.textColor = Colors.grayscale(4)
		self.detailTextLabel?.text = faculty_entry.email
		self.contentView.backgroundColor = Colors.grayscale(1)
	}
}
