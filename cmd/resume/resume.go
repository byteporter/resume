package main

import (
	"flag"
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"

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

func (vh resourceFileHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Vary", "Accept-Encoding")
	w.Header().Set("Cache-Control", "max-age=2592000") //30 days
	vh.h.ServeHTTP(w, req)
}

type resumeHandler struct {
	h          http.Handler
	contentDir string
}

func (rh resumeHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	b, _ := ioutil.ReadFile(filepath.Join(rh.contentDir, "resume.md"))
	var output = blackfriday.Run(b)

	s, _ := ioutil.ReadFile(filepath.Join(rh.contentDir, "static-root/resources/resume.min.css"))

	t, err := template.ParseFiles(filepath.Join(rh.contentDir, "templates/resume.gohtml"))

	if err != nil {
		fmt.Println(err)                              // Ugly debug output
		w.WriteHeader(http.StatusInternalServerError) // Proper HTTP response
		return
	}

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
	portPtr := flag.Int("p", 8080, "tcp port on which to listen")
	contentDir := flag.String("c", "/usr/share/resume", "directory containing the content to serve")

	flag.Parse()

	router := mux.NewRouter()
	router.Handle("/", handlers.CompressHandler(resumeHandler{nil, filepath.Clean(*contentDir)})).Methods("GET")
	fs := justFilesFilesystem{http.Dir(filepath.Join(*contentDir, "static-root/"))}
	rfh := handlers.CompressHandler(resourceFileHandler{http.StripPrefix("/", http.FileServer(fs))})
	router.PathPrefix("/").Handler(rfh)
	http.Handle("/", router)

	log.Fatal(http.ListenAndServe(strings.Join([]string{":", strconv.Itoa(*portPtr)}, ""), router))
}
