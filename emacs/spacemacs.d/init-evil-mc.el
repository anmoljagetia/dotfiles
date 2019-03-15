;; Multiple cursors
(use-package evil-mc
  :ensure t
  :config

  (defun evil--mc-make-cursor-at-col (startcol _endcol orig-line)
    (move-to-column startcol)
    (unless (= (line-number-at-pos) orig-line)
      (evil-mc-make-cursor-here)))
  (defun evil-mc-make-vertical-cursors (beg end)
    (interactive (list (region-beginning) (region-end)))
    (evil-mc-pause-cursors)
    (apply-on-rectangle #'evil--mc-make-cursor-at-col
                        beg end (line-number-at-pos (point)))
    (evil-mc-resume-cursors)
    (evil-normal-state)
    (move-to-column (evil-mc-column-number (if (> end beg)
                                               beg
                                             end)))))

;; enable the global evil multi caret mode
(global-evil-mc-mode t)

;; --------- HOW TO USE ----------------
;; 1. Enable if not enabled with :evil-mc-mode 1
;; 2. Select text
;; 3. Press C-n to create a next cursor for the same selection forwards
;; 4. Press C-p to create a next cursor for the same selection backwards
;; 5. 'g r n' to skip a forward match
;; 6. 'g r p' to skip a backward match
;; 7. Start editing with multiple cursors
;; 8. 'g r u' to remove all cursors
