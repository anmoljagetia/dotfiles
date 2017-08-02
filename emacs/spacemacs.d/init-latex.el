;; Latex
;; Use Skim on macOS to utilize synctex.
;; Confer https://mssun.me/blog/spacemacs-and-latex.html
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-start-server t)
(setq TeX-source-correlate-method 'synctex)
;; AucTex recognizes some standard viewers, but the default view command
;; does not appear to sync.
(setq TeX-view-program-list
      '(("Okular" "okular --unique %o#src:%n`pwd`/./%b")
        ("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")
        ("Zathura"
         ("zathura %o"
          (mode-io-correlate
           " --synctex-forward %n:0:%b -x \"emacsclient +%{line} %{input}\"")))))
(cond
 ((spacemacs/system-is-mac) (setq TeX-view-program-selection '((output-pdf "Skim"))))
 ;; For linux, use Okular or perhaps Zathura.
 ((spacemacs/system-is-linux) (setq TeX-view-program-selection '((output-pdf "Okular")))))
