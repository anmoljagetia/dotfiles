;; Python Autocomplete settings
;; Some autocomplete might not work since we have
;; since then set some defaults in autocomplete layer

(add-hook 'python-mode-hook 'anaconda-mode)
(eval-after-load "company"
  '(add-to-list 'company-backends '(company-anaconda :with company-capf)))
