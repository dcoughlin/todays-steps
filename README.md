# todays-steps
A Swift iOS application to demonstrate the use of the CMPemometer API that is part of the Core Motion framework.

To work with the demo app you’ll need to run it on an actual iPhone device, since it requires access to an M-Series motion coprocessor chip.  The simulator doesn't currently have motion coprocessor support, and while newer iPads contain the motion coprocessor chip, and support some motion activity services, step counting is not currently available.

When you run the application for the first time it will ask for permission to acess your Motion & Fitness Activity data.  If permission is granted, it will then display you current step count for the current day, as well as live updates as you walk or run.

Good Luck!
