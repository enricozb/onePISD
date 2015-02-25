# onePISD
iOS client for the Plano ISD school website, portal.mypisd.net

Made in Swift and works on iOS 8+

Uses [Alamofire](https://github.com/Alamofire/Alamofire) for HTTP requests.

## To Do

### Session.swift
![Progress](http://progressed.io/bar/44)

- [ ] Remove the way View and Session are intertwined.
- [x] Add storage mechanism for fields
	- [x] Grades
	- [x] StudendId
- [ ] Error handling/notification during requests
	- [x] Wrong Password
	- [x] No Internet connection
	- [ ] PISD issues (timeout)

### Parser.swift
![Progress](http://progressed.io/bar/14)

- [ ] Parse individual assignments
	- [x] Grade
	- [x] Category
	- [x] Date
	- [x] AssignmentId
	- [x] Assignment Name
	- [ ] Grade Weight value
	- [ ] Comment
- [ ] Grab Teacher information
- [ ] ```inout``` parameter types for forms
- [ ] Guarantee support for semester and 1.5 credit courses
- [ ] Fix slow NSScanner and substring performance
- [ ] Rewrite and polish for clarity (may never be checked)

### Features
![Progress](http://progressed.io/bar/25)

- [x] Display Grade Summary
- [ ] Display individual assignments
	- [x] Display category and grade
	- [ ] Sort individual assignments by date, category, or weight
- [ ] Display Attendance summary
- [ ] Grade calculation features
	- [ ] Semester Exam prediction for "maxing"
	- [ ] Calculate required Major grade for desired six weeks grade
- [ ] Add option to remember account
- [ ] Add a faculty contact page

### General

- [ ] Create UIViewController subclass to extend all app views from
- [ ] Finalize UI 
