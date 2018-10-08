# resume

Golang microservice for my professional resume

This is a simple web application to take my resume maintained in Markdown and turn it into a nice HTML page to display. You can see it at [jameslind.info](http://jameslind.info). It also includes a ConTeXt template to turn the Markdown resume into a nice pdf using pandoc. Other formats output are .docx and .rtf though these currently generate directly from the Markdown and are not formatted consistently with the website or pdf versions of the resume.

## How to use

Use go to build the application, which is a single file `resume.go`