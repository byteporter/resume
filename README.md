# resume

Golang microservice for my professional resume

This is a simple web application to take my resume maintained in Markdown and turn it into a nice HTML page to display. You can see it at [jameslind.info](http://jameslind.info). It also includes a ConTeXt template to turn the Markdown resume into a nice pdf using pandoc. Other formats output are .docx and .rtf though these currently generate directly from the Markdown and are not formatted consistently with the website or pdf versions of the resume.

## Goals

### Superior experience to a paper resume

I believe strongly in stewardship of the environment and preserving our resources. In order to promote conservation of resources, I decided that I would like to avoid people printing out paper copies of my resume. Pragmatically, the best way to achieve this goal was to provide an alternative with a better experience than a paper document would provide. To achieve this, I saught to provide a blazing fast online resume with highly accessible content regardless of the device used to read it.

To meet this goal, I have emphasized the content of the resume over the presentation. It is intended to be served from an easily remembered url (https://jameslind.info in my case) and not from the context of a larger site. In this way, I hope that people will easily remember how to retrieve it and avoid the temptation to print it out.

In the end however, I recognize that not everyone will agree with me. To suit this audience as well as retaining the ability to submit documents in a way that some job applications require, this project is also able to output a pdf document.

### Ease of maintenance

If a resume is a hassle to keep up to date, it's easy to neglect. The content of this resume is maintained in Markdown format. This allows easy focus on the content itself without worrying too much about presentation. Presentation concerns are handled by the CSS file for the online version and the ConTeXt template file for the pdf. Furthermore, the use of text based formats allows me to version control my resume easily using Git.

### More detail into my skills

Another benefit is that this resume is open source and available for potential employers to delve more deeply into my skills by viewing this repository.

## How to use

Write your resume content in Markdown format in the file `web/resume.md`. Website specific content (e.g. the title for the website) can be controlled with the gohtml template file `web/templates/resume.gohtml`. Style the website with the file `web/static-root/resources/resume.css`. Style the pdf document with the ConTeXt template `tools/genhardcopy/pdftemplate.tex`.
