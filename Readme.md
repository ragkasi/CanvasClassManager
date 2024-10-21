<h1>Hello my beauties</h1>
I have created 2 SDKs

* Carmen Canvas SDK
* OpenAI SDK

I implemented methods that when combined together can let the user browse to a carmen assignment that allows text submission and have chatGPT complete it automagically for them (including handling submission!) Grades can also be fetched for the GPA estimation idea

<h2>Environment Setup</h2>
<h3> 1. Dependencies</h3>

From now on, we should use package management (think requirements.txt in Python).\
This is straightforward with the Bundle gem. 
If you ever want to add a dependency just include it in the Gemfile.

1. Install bundle
```bash
gem install bundle
```

2. Install dependencies
```bash
bundle install
```
The above step should generate a Gemfile.lock which is used to track what versions of what you have installed. Dont touch it and don't commit it.

<h3> 2. Environmental variables</h3>

1. Make a copy of .envtemplate and rename it .env
2. Fill in the token information. Instructions for getting tokens are included in .env.
3. Please in the name of Baha dont commit your .env file. If it ever shows up after running `git status` there is a problem.

Options:

* Option 1: Get list of current courses on dashboard and the assignments (date timestamped)
* Option 2: TODO
* Option 3: Scrapes google to find relevant textbook for courses
* Option 4: Love is in the air! Finds ideal study dates in a class
