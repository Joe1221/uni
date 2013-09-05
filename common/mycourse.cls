% Class für Vorlesungen, etc

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mycourse}

\RequirePackage{etoolbox}
\ifundef{\ConfigFontsize}{\def\ConfigFontsize{12pt}}{}
\ifundef{\ConfigLanguage}{\def\ConfigLanguage{ngerman}}{}
\InputIfFileExists{config}{}{}

\PassOptionsToClass{fontsize=\ConfigFontsize}{scrbook}

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

% Old version of package libertine loads xcolor with conflicting options, so load it beforehand.
\RequirePackage[svgnames,x11names]{xcolor}  % ana3 needs x11names

%==================================
% Fonts / Encoding
%==================================

\RequirePackage[\ConfigLanguage]{babel} 	% Deutsche Sprachunterstützung für Silbentrennung, etc.
\RequirePackage[T1]{fontenc}		% Erlaubt das kopieren/suchen von/nach Umlauten im pdf-Dokument
\RequirePackage[utf8]{inputenc}		% Encoding der tex-Dateien, erlaubt direkte Eingabe von Sonderzeichen
%\RequirePackage{lmodern}			% Schönere Schriftart für pdf-Dokumente
\RequirePackage{libertine}                  % Libertine font
\RequirePackage[scaled=0.83]{beramono}      % Typewriter font scaled to fit with Libertine

% Load base class
\LoadClass{scrbook}
%==================================
% 
%==================================
\RequirePackage{amsmath}
\RequirePackage{amssymb}

\IfFileExists{CJK.sty}{
	\usepackage[encapsulated]{CJK}
	\newcommand{\japtext}[1]{\begin{CJK}{UTF8}{min}##1\end{CJK}}
}{
	\newcommand{\japtext}[1]{}
}

\RequirePackage[l2tabu,orthodox]{nag} 	% Warnt vor Nutzung von veralteten Befehlen und Packages
\RequirePackage{etex}

%\usepackage[cmintegrals,libertine,cmbraces,slantedGreek]{newtxmath}
%\usepackage{newtxmath}
%\usepackage[italic,defaultmathsizes]{mathastext}

\RequirePackage[a4paper, outer=21mm, inner=21mm, top=20mm, bottom=30mm, marginparwidth=18mm, marginparsep=3mm]{geometry}
\RequirePackage{graphicx}

%\RequirePackage[hidelinks]{hyperref}			% Macht Referenzen im pdf-Dokument anklickbar
\RequirePackage[pdftex]{hyperref}			% Macht Referenzen im pdf-Dokument anklickbar

\ifdefstring{\ConfigOutput}{print}{
	\definecolor{url}{HTML}{000000} % 0088cc
	\definecolor{link}{HTML}{000000}
	\definecolor{text}{HTML}{000000}
	\definecolor{math}{HTML}{000000}
	\definecolor{theoremtype}{HTML}{000000}
	\definecolor{theoremnumber}{HTML}{000000}
	\definecolor{theoremtitle}{HTML}{000000}
	\definecolor{header}{HTML}{000000}
	\definecolor{headerrule}{HTML}{000000}
	\definecolor{timestamp}{HTML}{000000}
	\definecolor{background}{HTML}{FFFFFF}
	\definecolor{headings}{HTML}{000000}
	% Nutze Serifen-Schrift für Druckversion
	\renewcommand*{\familydefault}{\rmdefault}
}{\ifdefstring{\ConfigOutput}{dark}{
	\definecolor{url}{HTML}{91AFED} % 0088cc
	\definecolor{link}{HTML}{91AFED}
	\definecolor{text}{HTML}{E2E2E5}
	\definecolor{math}{HTML}{E2E2E5}
	\definecolor{theoremtype}{HTML}{FF9800}
	\definecolor{theoremnumber}{HTML}{FF9800}
	\definecolor{theoremtitle}{HTML}{F6F3E8}
	\definecolor{header}{HTML}{F6F3E8}
	\definecolor{headerrule}{HTML}{FF9800}
	\definecolor{timestamp}{HTML}{7E8AA2}
	\definecolor{background}{HTML}{202020}
	\definecolor{headings}{HTML}{F6F3E8}
	\renewcommand*{\familydefault}{\sfdefault}
	\RequirePackage{sfmath}
}{
	\definecolor{url}{HTML}{005580} % 0088cc
	\definecolor{link}{HTML}{005580}
	\definecolor{text}{HTML}{111111}
	\definecolor{math}{HTML}{111111}
	\definecolor{theoremtype}{HTML}{004400}
	\definecolor{theoremnumber}{HTML}{222222}
	\definecolor{theoremtitle}{HTML}{222222}
	\definecolor{header}{HTML}{666666}
	\definecolor{headerrule}{HTML}{668866}
	\definecolor{timestamp}{HTML}{333333}
	\definecolor{background}{HTML}{FFFFFF}
	\definecolor{headings}{HTML}{000000}
}}

\renewcommand*\sectfont{\sffamily\bfseries\color{headings}}



\RequirePackage{microtype} 			% Für typographische Perfektion


\hypersetup{
    colorlinks=true,
    pdfborder={0 0 0},
    bookmarksnumbered=true,
    bookmarksopen=true,
    bookmarksopenlevel=1,
    pdfdisplaydoctitle=true,
	linktoc=all,
	%allcolors=link,
	urlcolor=url,
	linkcolor=link,
	citecolor=link,
	runcolor=link,
	menucolor=link,
	filecolor=link,
	anchorcolor=link,
}


% PDF Meta-Informationen setzen
%\makeatletter
\AtBeginDocument{
  \hypersetup{
    pdftitle = {\@title},
    pdfsubject = {\@title},
    pdfauthor = {\@author},
  }
  % Set text color and LaTeX default color (used in tables and other parts)
  \color{text}\global\let\default@color\current@color
  \pagecolor{background}
  %\everymath{\color{math}} % Currently broken, looking for clean, working solution
}
%\makeatother


% Erzeuge pdf-bookmark für das Inhaltsverzeichnis
\let\oldtableofcontents\tableofcontents
\renewcommand{\tableofcontents}{\pdfbookmark[0]{\contentsname}{toc}\oldtableofcontents}
%\BeforeTOCHead[toc]{{\pdfbookmark[0]{\contentsname}{toc}}} % Funktioniert nicht im CIP-Pool

%\RequirePackage{enumerate}			% Aufzählungen wie a), (I), etc. als optionales Argument
\RequirePackage[shortlabels]{enumitem}			% Aufzählungen wie a), (I), etc. als optionales Argument
\setlist{leftmargin=*}
\setlist[description]{style=standard,leftmargin=1em,labelsep=1em}

\RequirePackage{parskip}			% Entfernt Einrückung bei Absätzen und fügt vertikalen Abstand ein
\setlength{\parskip}{0.5em}

\RequirePackage{float}              % Erlaubt [H] Option für table/figure
%\RequirePackage{scrhack} 			% Wegen float-package, das eine warnung mit scrbook erzeugt

\RequirePackage{algpseudocode}		% algorithmicx package für Pseudo-Code
\RequirePackage{verbatim}			% Für Ascii-Art ;-)

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
% Theorems (TODO: extra package, also needed in mywork.cls)
%========================

% TODO: \theoremheadertypefont{bla} sollte funktionieren, wie?
\def\theorem@headertypefont{\color{theoremtype}} % Font für Theorem-Typ (Satz, Definition, etc.)


\newtheoremstyle{mythm}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}\ \color{theoremnumber}##2\theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}\ \color{theoremnumber}##2\ \color{theoremtitle}(##3)\theorem@separator}\hbox{\strut}}}]}
\newtheoremstyle{nonumbermythm}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}\ \theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}\ \color{theoremtitle}(##3)\theorem@separator}\hbox{\strut}}}]}
\theoremstyle{mythm} 								% Vordefinierter Style mit Zeilenumbruch


% Deprecated: (use \theorempreskip instead)
\theorempreskipamount 2.5em 						% Abstand vor Theroem
\theoremindent 1em 									% Theroem einrücken
\theoremheaderfont{\kern-1em\normalfont\bfseries} 	% Überschrift wieder ausrücken
\theorembodyfont{\normalfont}
%\theoremprework{
%}

\newtheorem{thm}{Theorem}[chapter]

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

\theorempreskipamount 1.0em % Abstand vor Theroem
\theoremheaderfont{\kern-1em\bfseries\small\itshape} % Kursiv und kleiner als oben

\theoremstyle{break}
\newtheorem*{note}{\color{headings}Bemerkung}

% Proof-Environment
% =================
% Führt \captions<lang> aus für \proofname, etc.
\csname captions\ConfigLanguage \endcsname
% Scheinbar wird \proofname überschrieben, wenn optionales Argument an \begin{proof} gegeben wird
\let\myproofname\proofname
\theoremsymbol{\ensuremath{\square}}
\theoremstyle{break}
\newtheorem*{proof}{\color{headings}\myproofname:}
\theoremsymbol{}


% Segment-Environment für kleinere gedankliche Abschnitte
% =======================================================
% Mit Zeilenumbruch
\newenvironment{seg}[1][]{\begin{description}[leftmargin=*,labelsep=1em]\item[{\color{headings}#1}]\hfill\\}{\end{description}}
% Ohne Zeilenumbruch
\newenvironment{segnb}[1][]{\begin{description}[leftmargin=*]\item[{\color{headings}#1}]}{\end{description}}


\RequirePackage{fancyhdr}
\RequirePackage{calc}
\pagestyle{fancy}

\fancyhead{}
\fancyfoot{}

\fancyheadoffset[RE,LO]{\marginparsep+\marginparwidth}
%\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
%\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter ~ \textbar ~ #1}{}}
\renewcommand{\sectionmark}[1]{\markright{\thesection ~ \textbar ~ #1}}
\fancyhf{}
\newcommand{\headerfont}{\bfseries \scshape \color{header}}
\fancyfoot[LE,RO]{\bfseries\color{header} \thepage}
\fancyhead[RO]{\headerfont\rightmark}
\fancyhead[LE]{\headerfont\leftmark}
\renewcommand{\headrulewidth}{0.4pt}

\renewcommand{\headrule}{{\color{headerrule}%
\hrule width\headwidth height\headrulewidth \vskip-\headrulewidth}}

% Pagestyle used in titlepages
\fancypagestyle{plain}{
  \fancyhf{}                        % Clear header/footer
  \fancyfoot[LE,RO]{\bfseries\color{header} \thepage}
  \renewcommand{\headrulewidth}{0pt}
}

%========================
% Common Math Things
%========================

\RequirePackage{mymath}
\RequirePackage{datetime} % After babel 
\newdateformat{coursedate}{\twodigit{\THEDAY}.\twodigit{\THEMONTH}.\THEYEAR}

\newcommand{\coursetimestamp}[3]{
	\marginline{
		\color{timestamp}\scshape\scriptsize \coursedate\formatdate{#1}{#2}{#3}
	}
}
