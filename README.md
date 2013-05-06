Working as an instructor can be an overwhelming job.  With so many students to keep track of, things are often forgotten or left incomplete.  The MobileTA app is designed to provide a way to keep track of class and student information, including attendance, seating charts, and participation from an iOS- or Android-based tablet, allowing instructors to use it during their instruction.

This project is based on a proposal submitted by Phil Anderson, an assistant professor in the College of Business.  Professor Anderson's classes are rewarded for their attendance and efforts in class and penalized for inappropriate or disrespectful behavior.  In order to record these notes, Professor Anderson needed to either walk around the room with a copy of the seating chart in order to mark attendance and points on it, or else keep the chart at his desk or lecturn and return to it whenever it needed to be updated.  Creating an electronic version of these records allows Professor Anderson to walk around with a single device that can be used to record data with MobileTA or look up lecture notes, and removes the burden of remembering to photocopy an easily-lost piece of paper before each class.

While this proposal was originally intended for college classes, we saw the chance to turn MobileTA into something that instructors at all grade levels could take advantage of.  With any luck, MobileTA will be able to streamline their teaching as well.

# Requirements/Specifications

**Devices**

One of the instructor's original demands was for MobileTA to run on his Apple iPad.  As a team, we felt that our target market could be better served by allowing educators to access a larger selection of devices with a broader price range.  This prompted us to split MobileTA into not one but two applications - one each for iOS and Android.  This allows users to use a device they're already familiar with (and sticking to each platform's user experience guidelines) and should make it easy for new users to understand our application.

**Class-Oriented**

A second requirement MobileTA meets is to allow the user to run only one class at a time.  This prevents instructors from consulting or making changes to the wrong information, such as updating a user's attendance to absent in an afternoon class when the user is registered for a morning class.  To facilitate teaching multiple classes, MobileTA must then allow for instructors to switch between classes when necessary.

**Class Data Entry**

Instructors must be able to enter information about each course they teach before the application can be of any use to them.  Once entered, MobileTA can use the information to differentiate between classes when the instructor wishes to view information for a different one, as well as to keep data relevant to a particular class together.  If the data is entered and presented appropriately, the instructor (and any substitutes) should be able to navigate directly to the information they want.

**Student Data Entry**

Educators tend to only teach a few sections or classes, but each section can have tens or hundreds of students, which makes data entry on a mobile device tiresome.  MobileTA needs to provide support importing and exporting individual class rosters via e-mail, and eventually storage and synchronization services like Dropbox to make this process more fluid.  The ability to add, edit, or remove students from the device is also important, since they can often add or drop a course on a whim.  Instructors also often want to take notes or save additional information (such as contact information) about each student, so supporting these practices is a must.

**Class Records**

Once the instructor is in class, MobileTA needs to allow instructors to take a roll call from the roster and mark students as present, absent, or tardy.  Since some instructors also grade on student participation or behavior in class, the same roster screen also needs to allow instructors to reward or penalize students with positive and negative participation points.

**Seating Chart**

For classes with assigned seating, MobileTA needs to provide a way for instructors to lay out the available desks in their classrooms and assign students to each.  Once in class, this same seating chart must allow for instructors to add the same attendance or participation markings as the class roster, and provide visual feedback of each.  This allows instructors to take roll through passive observation of the classroom.


# Architecture & Design

## Backend Design

Both the iOS and Android versions of MobileTA follow approximately the same underlying structure for storing and associating data.  At the heart of the application is a series of interrelated classes (each of which also happens to correspond with a table in a database).

* `Section` - `Section`s represent the instances of courses that students sign up for and attend, analogous to the sections available for course registration.  To make organization easier when the instructor is presented with a list, each section can be labelled with the course it belongs to, and then similar sections can be grouped together.

* `Room` - A `Room` object represents the classroom in which a section is regularly held.  Each `Room` has a name and can be associated with `Section`s.

* `Student` - A class is nothing without `Student`s registered for it.  Each instance of a `Student` represents a real student and contains vital details like their name, instructor notes about each individual, and their associations to a group and attendance history.

* `Seat` - A `Seat` represents a single desk or other seating position (e.g. a table) in a room.  It has coordinates that indicate its location in the room (used when drawing the seating chart) and associations with the `Room` it is located in and the `Student`s from each section that 

* `AttendanceRecord` - An `AttendanceRecord` represents a particular period for each `Section` for which the instructor was taking attendance or awarding participation points, be it a class session, exam, or other outside event.  An `AttendanceRecord` encompasses all students in a `Section`, analogous to an attendance column in the instructor's gradebook.

* `StudentAttendance` - The `StudentAttendance` class represents a particular `Student` and their attendance and behavior for a particular `AttendancePeriod` (the intersection between student row and attendance column in a paper gradebook).  If the student was late to class that day, their `StudentAttendance` record would reflect their tardy attendance.  Similarly, a student awarded participation points for contributing to class discussion would have those points reflected in their `StudentAttendance` record.

* `Group` - Our customer runs his classes by assigning students into one of a number of groups for the duration of the semester.  This class maintains basic information about each defined group in the class and enables us to query based on associations to each `Group`.

## User Interface

MobileTA uses the "One-Window Drill-Down" pattern to present information.  The current requirements for MobileTA specify that it runs on tablet devices, which often use a multi-paned layout to take advantage of extra screen space.  While we could make this work, we opted for the drill-down method because of the amount of information displayed at once and because it will allow us to easily add support for large-screen phones in future releases.

# Setup

In order to develop either of the MobileTA applications, you'll need to set up your development system according to the requirements listed in each section.

## Development Environment

To develop MobileTA for iOS, you'll need the following items.  For software items, they should be installed according to the directions listed on their respective product websites.

* A computer running a recent version of OS X (10.7 Lion or 10.8 Mountain Lion)
* Apple's [Xcode][AppleXcode] Development Environment with the iOS SDK installed
* A [Git] client (officially-supported clients and most third-party tools like [SourceTree] or [Gitti] should work)
* *Optional:* To test MobileTA on a physical device instead of a simulator:
    * An active [Apple iOS Developer subscription][AppleDeveloperSubscription]
    * A device running iOS 5.1 or greater attached to the same developer account

## Source Code

Once your development environment has been set up, it's time to get the latest version of the source code and import it into your environment.

1. Using your Git client, clone the following Git repository into your workspace:

    <https://github.com/SSheldon/MobileTA-iOS>

    *Note:* The MobileTA iOS repository makes use of Git submodules for third-party libraries.  Make sure to configure your Git client to fetch the submodules or manually run 

2. Once the repository has been cloned, locate the `MobileTA.xcodeproj` file in the repository root.  Open this file.

3. If Xcode detects that your development environment is out of date, it may ask you to update.  Accept any and all updates and wait for them to install.

4. Xcode will open the project in a new window.  The first time the project is opened, Xcode will generate an index of the source code in the project, and may download supporting material from Apple.

# Installation Instructions

The installation instructions provided below are for developers installing test builds of the applications to their personal devices for testing.

1. Ensure that your device has free space for new applications.  Connect your test device to your computer using an appropriate cable.

2. Open the MobileTA project in Xcode if it is not already.

3. In the main Xcode toolbar, locate the "Scheme" bar.  It should be towards the left side of the toolbar if the toolbar is visible.  Click on the right side of the Scheme button to select between a physical device or a simulated device.

4. Click the **Run** button on the toolbar or press **Command + R** on your keyboard.

5. Xcode should install the application to the device (as well as a development certificate, if necessary).  MobileTA should start, and Xcode should confirm that the application is now running.

<!-- Link References -->

[AppleDeveloperSubscription]: https://developer.apple.com/devcenter/ios/index.action
[AppleXcode]: https://itunes.apple.com/us/app/xcode/id497799835?mt=12
[Git]: http://git-scm.com
[Gitti]: http://www.gittiapp.com/
[SourceTree]: http://www.sourcetreeapp.com/
