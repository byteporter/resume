package main

import (
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/russross/blackfriday"
)

type justFilesFilesystem struct {
	fs http.FileSystem
}

func (fs justFilesFilesystem) Open(name string) (http.File, error) {
	f, err := fs.fs.Open(name)
	if err != nil {
		return nil, err
	}
	return neuteredReaddirFile{f}, nil
}

type neuteredReaddirFile struct {
	http.File
}

func (f neuteredReaddirFile) Readdir(count int) ([]os.FileInfo, error) {
	return nil, nil
}

type resourceFileHandler struct {
	h http.Handler
}

type resumeHandler struct {
	h http.Handler
}

func (vh resourceFileHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Vary", "Accept-Encoding")
	w.Header().Set("Cache-Control", "max-age=2592000") //30 days
	vh.h.ServeHTTP(w, req)
}

func (rh resumeHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	b, _ := ioutil.ReadFile(`resume.md`)
	var output = blackfriday.Run(b)

	s, _ := ioutil.ReadFile(`static-root/resources/resume.min.css`)

	t, _ := template.ParseFiles("templates/resume.gohtml")

	templateData := struct {
		Body  template.HTML
		Style template.CSS
	}{
		template.HTML(output),
		template.CSS(s),
	}

	w.Header().Set("Vary", "Accept-Encoding")
	t.Execute(w, templateData)
}

func main() {
	router := mux.NewRouter()
	router.Handle("/", handlers.CompressHandler(resumeHandler{})).Methods("GET")
	fs := justFilesFilesystem{http.Dir("static-root/")}
	rfh := handlers.CompressHandler(resourceFileHandler{http.StripPrefix("/", http.FileServer(fs))})
	router.PathPrefix("/").Handler(rfh)
	http.Handle("/", router)
	log.Fatal(http.ListenAndServe(":80", router))
}
