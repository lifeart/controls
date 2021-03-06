BaseInput {
	property float max;
	property float min;
	property float step;
	property float value;
	horizontalAlignment: BaseInput.AlignHCenter;
	width: 50;
	height: 25;
	type: "number";

	onMinChanged: { this.element.dom.min = value; }
	onMaxChanged: { this.element.dom.max = value; }
	onStepChanged: { this.element.dom.step = value; }
	onValueChanged: { this.element.dom.value = value; }

	constructor: {
		this.element.on("input", function() {
			this.value = this.max ? Math.min(this.max, this.element.dom.value) : this.element.dom.value
		}.bind(this))
	}
}
