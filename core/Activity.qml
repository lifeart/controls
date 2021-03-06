/// very usefull for single page applications, aimed to simplify logic between root and children Activities
Item {
	property bool active;					///< is current Activity active or not
	property bool hasAnyActiveChild: false;	///< is 'true' when corresponded activity has active child
	property string currentActivity: "";	///< displays current active activity name
	property string name;					///< activity name
	signal started;		///< activity was started signal
	signal stopped;		///< activity was stopped signal

	///@private
	isActivity(obj): { return obj instanceof _globals.controls.core.Activity; }

	/// checking child activities if there is at least one
	isAnyActiveInContext: {
		var children = this.parent.children;
		for (var i in children)
			if (this != children[i] && this.isActivity(children[i]) && children[i].active)
				return true;
		return false;
	}

	/// close all child activities
	closeAll: {
		var children = this.children;
		for (var i in children)
			if (this != children[i] && this.isActivity(children[i]))
				children[i].stop();
	}

	/// stop all activities from one common parent
	closeParentActivities: {
		var children = this.parent.children ? this.parent.children : this.children;
		for (var i in children)
			if (this != children[i] && this.isActivity(children[i]))
				children[i].stop();
	}

	/// start activity
	start: {
		if (this.active)
			return;

		if (this.parent && this.isActivity(this.parent)) {
			this.closeParentActivities();
			this.parent.hasAnyActiveChild = true;
			this.parent.currentActivity = this.name;
		}

		this.started();
		this.visible = true;
		this.active = true;
		this.setFocus();
		log("Activity started: ", this.name);
	}

	/// stop activity
	stop: {
		if (!this.active)
			return;

		this.active = false;
		if (this.parent && this.isActivity(this.parent)) {
			this.parent.currentActivity = this.parent.name;
			this.parent.hasAnyActiveChild = this.isAnyActiveInContext();
			this.parent.started()
		}
		this.stopped();
		log("Activity stopped: ", this.name);
	}

	///@private
	onBackPressed: {
		if (this.active)
			this.stop();
		return true
	}
}
