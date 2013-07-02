% Class für Vorlesungen, etc

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mycourse}

% 
\PassOptionsToClass{fontsize=12pt}{scrbook}

%==================================
% Options
%==================================
% pass-through unknown options
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}}


% [noproofs] compile without proofs
% ---------------------------------
\DeclareOption{noproofs}{
    \AtEndOfClass{
        \RequirePackage{environ}
        \let\proof\relax
        \let\endproof\relax
        \NewEnviron{proof}{}
    }
}

% [sectionpagebreak] Neue Seite für den Beginn jeder section
% ----------------------------------------------------------
\DeclareOption{sectionpagebreak}{
    \AtEndOfClass{
		\let\oldsection\section
		\renewcommand\section{\clearpage\oldsection}
	}
}


\ProcessOptions\relax


%==================================
% Fonts / Encoding
%==================================

\RequirePackage[ngerman]{babel} 	% Deutsche Sprachunterstützung für Silbentrennung, etc.
\RequirePackage[T1]{fontenc}		% Erlaubt das kopieren/suchen von/nach Umlauten im pdf-Dokument
\RequirePackage[utf8]{inputenc}		% Encoding der tex-Dateien, erlaubt direkte Eingabe von Sonderzeichen
\RequirePackage{lmodern}			% Schönere Schriftart für pdf-Dokumente

% Load base class
\LoadClass{scrbook}
%==================================
% 
%==================================

\IfFileExists{CJK.sty}{
	\usepackage[encapsulated]{CJK}
	\newcommand{\japtext}[1]{\begin{CJK}{UTF8}{min}##1\end{CJK}}
}{
	\newcommand{\japtext}[1]{}
}

%\RequirePackage[l2tabu, orthodox]{nag} 	% Warnt vor Nutzung von veralteten Befehlen und Packages
\RequirePackage{etex}

\RequirePackage{microtype} 			% Für typographische Perfektion

\RequirePackage[a4paper, outer=21mm, inner=21mm, top=20mm, bottom=30mm, marginparwidth=18mm, marginparsep=3mm]{geometry}
\RequirePackage{graphicx}
\RequirePackage[svgnames,x11names]{xcolor}  % ana3 needs x11names

%\RequirePackage[hidelinks]{hyperref}			% Macht Referenzen im pdf-Dokument anklickbar
\RequirePackage[pdftex]{hyperref}			% Macht Referenzen im pdf-Dokument anklickbar
\hypersetup{
    colorlinks=false,
    pdfborder={0 0 0},
}

% PDF Meta-Informationen setzen
%\makeatletter
\AtBeginDocument{
  \hypersetup{
    pdftitle = {\@title},
    pdfsubject = {\@title},
    pdfauthor = {\@author},
  }
}
%\makeatother


% Erzeuge pdf-bookmark für das Inhaltsverzeichnis
\let\oldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{\pdfbookmark[0]{\contentsname}{toc}\oldtableofcontents}
%\BeforeTOCHead[toc]{{\pdfbookmark[0]{\contentsname}{toc}}} % Funktioniert nicht im CIP-Pool

\RequirePackage{enumerate}			% Aufzählungen wie a), (I), etc. als optionales Argument
\RequirePackage{parskip}			% Entfernt Einrückung bei Absätzen und fügt vertikalen Abstand ein
\setlength{\parskip}{0.5em}

\RequirePackage{float}              % Erlaubt [H] Option für table/figure
%\RequirePackage{scrhack} 			% Wegen float-package, das eine warnung mit scrbook erzeugt

\RequirePackage{algpseudocode}		% algorithmicx package für Pseudo-Code
\RequirePackage{verbatim}			% Für Ascii-Art ;-)

\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage[amsmath,hyperref,thmmarks]{ntheorem}			% Alternative theorems für leichteres Anpassen
\RequirePackage{tikz}


\RequirePackage{listings}			% Einbinden von Code-Schnipsel
% Hack um deutsche Sonderzeichen in lstinputlisting zu unterstützen
\lstset{literate={Ö}{{\"O}}1{Ä}{{\"A}}1{Ü}{{\"U}}1{ß}{{\ss}}2{ü}{{\"u}}1{ä}{{\"a}}1{ö}{{\"o}}1}
\lstset{
  basicstyle=\small\ttfamily,
  numbers=left,
  columns=fullflexible,
  breaklines=true,
  mathescape=true,
  escapechar=\#,
  tabsize=4,
  frame=lines,
  showstringspaces=false
}

%========================
% Theorems (TODO: extra package)
%========================

% TODO: \theoremheadertypefont{bla} sollte funktionieren, wie?
\def\theorem@headertypefont{\color{green!25!black}}

\newtheoremstyle{mythm}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\theorem@headertypefont##1}\ \color{black}##2\theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\theorem@headertypefont##1}\ \color{black}##2\ (##3)\theorem@separator}\hbox{\strut}}}]}
\newtheoremstyle{nonumbermythm}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\theorem@headertypefont##1}\ \theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\theorem@headertypefont##1}\ (##3)\theorem@separator}\hbox{\strut}}}]}
\theoremstyle{mythm} 								% Vordefinierter Style mit Zeilenumbruch


% Deprecated: (use \theorempreskip instead)
\theorempreskipamount 2.5em 						% Abstand vor Theroem
\theoremindent 2ex 									% Theroem einrücken
\theoremheaderfont{\kern-1em\normalfont\bfseries} 	% Überschrift wieder ausrücken
%\theoremheadertypefont{\color{green!25!black}}% Font für Theorem-Typ (Satz, Definition, etc.)
\theorembodyfont{\normalfont} 						% Aufrecht statt kursiv im body-Teil
%\theoremprework{
%	\def \theorem@headertypefont{\the\theoremheadertypefont}
%}

% Nummerierung ist anders in scrbook (Skripte) <-> scrartcl (Abgaben)
\@ifclassloaded{scrbook}{
	\newtheorem{thm}{Theorem}[chapter]
}{
	\newtheorem{thm}{Theorem}[section]
}
\renewtheorem*{thm*}{Theorem}
\newtheorem{st}[thm]{Satz}
\renewtheorem*{st*}{Satz}
\newtheorem{lem}[thm]{Lemma}
\renewtheorem*{lem*}{Lemma}
\newtheorem{df}[thm]{Definition}
\renewtheorem*{df*}{Definition}
\newtheorem{conv}[thm]{Konvention}
\renewtheorem*{conv*}{Konvention}
\newtheorem{kor}[thm]{Korrolar}
\renewtheorem*{kor*}{Korrolar}
\newtheorem{prop}[thm]{Proposition}
\renewtheorem*{prop*}{Proposition}
\newtheorem{alg}[thm]{Algorithmus}
\renewtheorem*{alg*}{Algorithmus}

\newtheorem{nt}[thm]{Bemerkung}
\renewtheorem*{nt*}{Bemerkung}
\newtheorem{ex}[thm]{Beispiel}
\renewtheorem*{ex*}{Beispiel}

%\theoremheadertypefont{\color{black}} % Font für Theorem-Typ (Satz, Definition, etc.)
\theoremstyle{break}


\theorempreskipamount 1.5em 								% Abstand vor Theroem
\theoremheaderfont{\kern-1em\bfseries\small\itshape}% Kursiv und kleiner als oben

\newtheorem*{note}{Bemerkung}

% Beweis
% TODO: Beweissymbol taucht nicht auf, wenn Beweis mit einer environment abgeschlossen wurde
\theoremsymbol{\ensuremath{\square}}
\newtheorem*{proof}{Beweis:}
\theoremsymbol{}

\newcommand{\qedhere}{ ${}$  }


% Segment-Environment für kleinere gedankliche Abschnitte
% TODO: Abstand ist nicht optimal, wenn vor segment-Umgebung eine andere environment war und kein text.
\theoremstyle{emptybreak}
\theoremheaderfont{\kern-2em\bfseries\small}
\theoremindent 2em 									% Theroem einrücken
\theoremprework{
	%\setlength\theorempreskipamount{5ex}\setlength\theorempostskipamount{5cm}
	\ \\ % Erzwinge Absatz, sonst komische Überschneidungsprobleme
	\vspace{-2em}
	%\topsep
}
\newtheorem{seg}{}

\RequirePackage{fancyhdr}
\RequirePackage{calc}
\pagestyle{fancy}

\fancyhead{}
\fancyfoot{}

\@ifclassloaded{scrbook}{
	\fancyheadoffset[RE,LO]{\marginparsep+\marginparwidth}
	%\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
	%\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}
	\renewcommand{\chaptermark}[1]{\markboth{\thechapter ~ \textbar ~ #1}{}}
	\renewcommand{\sectionmark}[1]{\markright{\thesection ~ \textbar ~ #1}}
	\fancyhf{}
	\newcommand{\headerfont}{\bfseries \scshape \color{gray}}
	\fancyfoot[LE,RO]{\bfseries\color{gray} \thepage}
	\fancyhead[RO]{\headerfont\rightmark}
	\fancyhead[LE]{\headerfont\leftmark}
	\renewcommand{\headrulewidth}{0.4pt}

	\renewcommand{\headrule}{{\color{gray}%
	\hrule width\headwidth height\headrulewidth \vskip-\headrulewidth}}


	% Pagestyle used in titlepages
	\fancypagestyle{plain}{
	  \fancyhf{}                        % Clear header/footer
	  \fancyfoot[LE,RO]{\bfseries\color{gray} \thepage}
	  \renewcommand{\headrulewidth}{0pt}
	}
}{
}

%========================
% Common Math Things
%========================

\RequirePackage{mymath}

\RequirePackage[ddmmyyyy,ngerman]{datetime}
\renewcommand{\dateseparator}{.}

\newcommand{\coursetimestamp}[3]{
	\marginline{
		\color{darkgray}\scshape\scriptsize \formatdate{#1}{#2}{#3}
	}
}
