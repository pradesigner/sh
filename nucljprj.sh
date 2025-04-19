#!/usr/bin/env zsh

#######################################################################
# New CLJ Prj                                                         #
#                                                                     #
# AUTH: pradesigner                                                   #
# VDAT: v1 - <2025-03-04 Tue>                                         #
# PURP: Sets up a new CLJ prj.                                        #
#                                                                     #
# Creates a new CLJ prj with minimal items: prjname, deps.edn,        #
# src/core.clj, test/, build.clj, .gitignore, resources/, README.org, #
# but leaving out some of the other items that was in Sean Corfield's #
# setup.                                                              #
#######################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: Create a new CLJ project."
    echo "how: nucljprj.sh <PRJ name>"
    exit
fi

# check if prj name is provided
if [ $# -eq 0 ]; then
    echo "Provide a project name."
    exit 1
fi



#############
# Variables #
#############
PRJ=$1



#############
# Functions #
#############



########
# Main #
########

# create prj directory
mkdir ~/clj/$PRJ
cd ~/clj/$PRJ


# create deps.edn
cat <<EOF > deps.edn
{:paths ["src" "resources"]
 :deps {org.clojure/clojure {:mvn/version "1.11.1"}}
 :aliases
 {:build {:deps {io.github.clojure/tools.build {:git/tag "v0.9.4" :git/sha "76b78fe"}}
          :ns-default build}
  :test {:extra-paths ["test"]
         :extra-deps {org.clojure/test.check {:mvn/version "1.1.1"}}}}}
EOF


# create README.org
cat <<EOF > README.org
$PRJ

abstract

* Description

* Installation

* Usage

* Configuration

* Testing

* License
  Program is copyleft. All items are created by pradesigner often with help from perplexity AI, unless otherwise credited.
EOF


# create build.clj for tools.build
cat << EOF > build.clj
(ns build
  (:require [clojure.tools.build.api :as b]))

(def class-dir "target/classes")
(def basis (b/create-basis {:project "deps.edn"}))
(def uber-file (format "target/%s-standalone.jar" (name (first (b/java-main-class basis)))))

(defn clean [_]
  (b/delete {:path "target"}))

(defn uber [_]
  (clean nil)
  (b/copy-dir {:src-dirs ["src" "resources"]
               :target-dir class-dir})
  (b/compile-clj {:basis basis
                  :src-dirs ["src"]
                  :class-dir class-dir})
  (b/uber {:class-dir class-dir
           :uber-file uber-file
           :basis basis
           :main '$PROJECT_NAME.core}))
EOF


# create dirs
mkdir -p test/$PRJ src/$PRJ resources docs


# create docs/README.org
cat <<EOF > docs/README.org
Any extra documentation is placed in this directory.

EOF

# create test/core-test.clj
cat << EOF > test/core-test.clj
(ns $PRJ.core-test
  (:require [clojure.test :refer :all]
            [$PRJ.core :as core]))

(deftest sample-test
  (testing "A basic test example"
    (is (= 4 (+ 2 2)))))

(deftest core-function-test
  (testing "Test a function from core namespace"
    (is (= "Hello, World!" (with-out-str (core/-main))))))
EOF


# create the core file
cat << EOF > src/$PRJ/core.clj
(ns $PROJECT_NAME.core)

(defn -main [& args]
  (println "Hello, World!"))
EOF


# Create .gitignore
cat << EOF > .gitignore
/target
/classes
/checkouts
profiles.clj
pom.xml
pom.xml.asc
*.jar
*.class
/.lein-*
/.nrepl-port
/.prepl-port
.hgignore
.hg/
.cpcache/
EOF


# setup git on github
git init
git add .
git commit -m "Initial commit: Add base files"
git branch -M main
gh repo create pradesigner/$PRJ --public --source=. --remote=origin
git push -u origin main


exit



#########
# Notes #
#########

to delete a repo use (may need to authenticate first):

% gh repo delete test                         
? Type pradesigner/test to confirm deletion: pradesigner/test
✓ Deleted repository pradesigner/test


