\RequirePackage {expl3, l3keys2e, xparse}
\ProvidesExplClass {mycourse} {2013/11/16} {0.1}
	{Class intended for math courses}
\RequirePackage {l3backports}

%%=======================================================================
%% Messages
%%=======================================================================

\msg_new:nnn {mycourse} {config_loaded} {
	Loaded~configuration~from~`config.tex`.
}
\msg_new:nnn {mycourse} {config_missing} {
	No~configuration~file~`config.tex`~found.
}


%%=======================================================================
%% Options
%%=======================================================================

% Define option keys
% ------------------------------------------------------------------------
\keys_define:nn {mycourse} {

	% [noproofs] compile without proofs
	noproofs .code:n         =
		\AtEndOfClass{
			\RequirePackage{environ}
			\let\proof\relax
			\let\endproof\relax
			\NewEnviron{proof}{}
		}
	,

	% [sectionpagebreak] Neue Seite für den Beginn jeder section
	sectionpagebreak .code:n =
		\AtEndOfClass{
			\let\oldsection\section
			\renewcommand\section{\clearpage\oldsection}
		}
	,

	% [lang] Language option (ngerman, english, …)
	lang .code:n             = \PassOptionsToPackage { #1 } { babel },
	lang .tl_set:N           = \l_mycourse_language,

	% [paper-size] (a4, a5) Controls the output paper size
	paper-size .choice:,
	paper-size / a4 .code:n  =
		\PassOptionsToPackage{
			a4paper,
			outer=21mm,
			inner=21mm,
			top=20mm,
			bottom=30mm,
			marginparwidth=18mm,
			marginparsep=3mm
		}{geometry}
		\PassOptionsToPackage{scaled=0.83}{beramono}
		\PassOptionsToClass{fontsize=12pt}{scrbook}
	,
	paper-size / a5 .code:n  =
		\PassOptionsToPackage{
			reset,
			a5paper,
			top=1.4cm,
			bottom=2.1cm,
			left=1.6cm,
			right=1.6cm,
			footskip=0.7cm,
			headsep=0.3cm,
			marginparwidth=1.7cm,
			marginparsep=0.2cm,
		}{geometry}
		%\PassOptionsToPackage{scaled=0.785}{beramono}
		\PassOptionsToPackage{scaled=0.83}{beramono}
		\PassOptionsToClass{fontsize=10pt}{scrbook}
	,
	a5 .code:n               = \keys_set:nn {mycourse} {paper-size=a5},
	a4 .code:n               = \keys_set:nn {mycourse} {paper-size=a4},
	a5book .code:n           = \keys_set:nn {mycourse} {paper-size=a5},
	book .code:n             =
		\keys_set:nn { mycourse } { paper-size=a5 }
		\keys_set:nn { mycourse } { style = default-print }
	,

	% [style] (dark,default,default-print)
	style .tl_set:N          = \l_mycourse_style,

	semester .tl_set:N       = \l_mycourse_semester,

}

% Option Defaults
% -----------------------------------------------------------------------
%\keys_define:nn {mycourse} {
%	lang .initial:n       = ngerman,
%	paper-size .initial:n = a5,
%}
\keys_set:nn {mycourse}{lang=german}
\keys_set:nn {mycourse}{paper-size=a5}
\keys_set:nn { mycourse } { semester = ~ }

% Load configuration file, containing additional options, e.g. in the form
% \PassOptionsToClass{paper-format=a4}{mycourse}
% ------------------------------------------------------------------------
\file_if_exist:nTF {config} {
	\file_input:n {config}
	\msg_info:nn {mycourse} {config_loaded}
}{
	\msg_warning:nn {mycourse} {config_missing}
}

% Finally process options passed to this class
\ProcessKeysOptions {mycourse}





\RequirePackage[l2tabu, orthodox]{nag} 	% Warnt vor Nutzung von veralteten Befehlen und Packages
% Old version of package libertine loads xcolor with conflicting options, so load it beforehand.
\RequirePackage[svgnames,x11names]{xcolor}  % ana3 needs x11names

%==================================
% Fonts / Encoding / i18n
%==================================

\RequirePackage { fontspec }

\setmainfont [
	Ligatures = TeX,
	Extension = .otf,
	UprightFont = *_R,
	BoldFont = *_RB,
	ItalicFont = *_RI,
	BoldItalicFont = *_RBI,
] { LinLibertine }

% Inconsolatazi4-* and package zi4 exists since texlive 2013,
% handle older distributions conditionally
\IfFileExists { zi4.sty } {
	\setmonofont [
		Ligatures = TeX,
		Extension = .otf,
		UprightFont = *-Regular,
		BoldFont = *-Bold,
	] { Inconsolatazi4 }
} {
	\setmonofont [
		Ligatures = TeX
	] { Inconsolata }
}

\RequirePackage { polyglossia }

\ExplSyntaxOff
    \setmainlanguage [ spelling=new, latesthyphen=true, babelshorthands=true ] {german}
%\setmainlanguage[babelshorthands=true]{german}
\ExplSyntaxOn


% Load base class
\LoadClass{scrbook}
%==================================
% 
%==================================
\RequirePackage{amsmath}
\RequirePackage{amssymb}

\RequirePackage{etex}

\RequirePackage{geometry}
\RequirePackage{graphicx}

\RequirePackage{float}              % Erlaubt [H] Option für table/figure (load before hyperref)
\RequirePackage{scrhack} 			% Wegen float-package, das eine warnung mit scrbook erzeugt

\definecolor{url}{HTML}{005580} % 0088cc
\definecolor{link}{HTML}{005580}
\definecolor{text}{HTML}{000000}
\definecolor{math}{HTML}{000000}
\definecolor{theoremtype}{HTML}{115908}
\definecolor{theoremnumber}{HTML}{222222}
\definecolor{theoremtitle}{HTML}{222222}
\definecolor{header}{HTML}{666666}
\definecolor{headerrule}{HTML}{337733}
\definecolor{timestamp}{HTML}{333333}
\definecolor{algcomment}{HTML}{444444}
\definecolor{algcommand}{HTML}{000055}
\definecolor{background}{HTML}{FFFFFF}
\definecolor{headings}{HTML}{000000}
\definecolor{termdef}{HTML}{000000}

\cs_if_exist:NT \str_case_x:nnF {
\str_case_x:nn \l_mycourse_style {
	{default-print} {
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
		\definecolor{algcomment}{HTML}{000000}
		\definecolor{algcommand}{HTML}{000000}
		\definecolor{background}{HTML}{FFFFFF}
		\definecolor{headings}{HTML}{000000}
		% Nutze Serifen-Schrift für Druckversion
		\renewcommand*{\familydefault}{\rmdefault}
	}
	{dark} {
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
	}
}
}

\renewcommand*\sectfont{\sffamily\bfseries\color{headings}}



\RequirePackage [ xindy ] { imakeidx }
\makeindex [
    name = terms,
    title = Begriffe, % fixme: i8n
    options = -I omega, % texindy has issues with utf8 otherwise
]
\makeindex [
    name = lectures,
    title = Vorlesungen, % fixme: i8n
    options = -I omega, % texindy has issues with utf8 otherwise
]

% emphasize a definition term and create index entry simultaneously
\DeclareDocumentCommand { \emphdef } { om } {
    \index [ terms ] {
	\IfNoValueTF { #1 } { #2 } { #1 }
    }
    { \color { termdef } \textit { #2 } }
}

\RequirePackage { datetime }
\newdateformat { coursedate } {
    \twodigit { \THEDAY } .
    \twodigit { \THEMONTH } .
    \THEYEAR
}
\DeclareDocumentCommand { \coursetimestamp } { mmm } {
    \index [ lectures ] {
	#3 - #2 - #1
	@
	\coursedate { \protect \formatdate { #1 } { #2 } { #3 } }
    }
    \marginline{
	\color { timestamp } \scshape \scriptsize
	\coursedate
	\formatdate { #1 } { #2 } { #3 }
    }
}


%\RequirePackage[hidelinks]{hyperref}			% Macht Referenzen im pdf-Dokument anklickbar
\RequirePackage{hyperref}			% Macht Referenzen im pdf-Dokument anklickbar

\RequirePackage{microtype} 			% Für typographische Perfektion


\hypersetup{
    colorlinks=true,
    pdfborder={0~0~0},
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

\RequirePackage[hypcap]{caption}


% Erzeuge pdf-bookmark für das Inhaltsverzeichnis
\cs_new_eq:NN \mycourse_tableofcontents_old: \tableofcontents
\DeclareDocumentCommand { \tableofcontents } { } {
    \cleardoublepage % keeps bookmark anchor and toc on same page
    \pdfbookmark [ 0 ] { \contentsname } { toc }
    \mycourse_tableofcontents_old:
}

\RequirePackage [ shortlabels ] { enumitem }     % Aufzählungen wie a), (I), etc. als optionales Argument

% These must be inside one \setlist definition
\setlist {
	leftmargin  = *,
	labelindent = 0.5em, % Fallback for cases when leftmargin=* is set manually
	% The following fixes leftmargin, sets a fixed distance of the label from
	% the item and allows the label to extend to the left as needed
	% (leftmargin=* should be set manually in cases where the label is too
	% long, in which case the above labelindent gets used)
	leftmargin = 2.1em,
	labelwidth = 2.0em,
	labelsep* = 0.4em
}
\setlist [ enumerate ] { leftmargin = 2.1em }
\setlist [ itemize ] { leftmargin = 1.6em }
\setlist [ description ] {
	style       = nextline,
	labelindent = 0.9em,
	leftmargin  = 2.5em,
	font        = \normalfont\small\bfseries,
}


\RequirePackage{parskip}			% Entfernt Einrückung bei Absätzen und fügt vertikalen Abstand ein
\setlength{\parskip}{0.5em}

\RequirePackage{algpseudocode}		% algorithmicx package für Pseudo-Code

\cs_new:Nn \mycourse_algcommand_style: { \ttfamily \color{algcommand} }

\DeclareDocumentCommand { \Return } { m } { \State { \mycourse_algcommand_style: return} ~ #1 }

\algrenewcommand { \algorithmiccomment } [ 1 ] { \hfill \mbox{ » ~ { \slshape \color{algcomment} #1 } } }
\algrenewcommand { \algorithmicwhile } { { \mycourse_algcommand_style: while } }
\algrenewcommand { \algorithmicdo } { { \mycourse_algcommand_style: do } }
\algrenewcommand { \algorithmicend } { { \mycourse_algcommand_style: end } }
\algrenewcommand { \algorithmicfor } { { \mycourse_algcommand_style: for } }
\algrenewcommand { \algorithmicif } { { \mycourse_algcommand_style: if } }
\algrenewcommand { \algorithmicthen } { { \mycourse_algcommand_style: then } }
\algrenewcommand { \algorithmicelse } { { \mycourse_algcommand_style: else } }
\algrenewcommand { \algorithmicrepeat } { { \mycourse_algcommand_style: repeat } }
\algrenewcommand { \algorithmicuntil } { { \mycourse_algcommand_style: until } }

\RequirePackage{verbatim}			% Für Ascii-Art ;-)

%\RequirePackage{mathtools}
\RequirePackage[amsmath,hyperref,thmmarks]{ntheorem}			% Alternative theorems für leichteres Anpassen
\RequirePackage{tikz}


\RequirePackage{listings}			% Einbinden von Code-Schnipsel
% Hack um deutsche Sonderzeichen in lstinputlisting zu unterstützen
\lstset{literate={Ö}{{\"O}}1{Ä}{{\"A}}1{Ü}{{\"U}}1{ß}{{\ss}}2{ü}{{\"u}}1{ä}{{\"a}}1{ö}{{\"o}}1}
\lstset{
  basicstyle=\ttfamily,
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

% Hack to prevent bold math in theorem title
\def\theorem@checkbold{}

\newtheoremstyle{mythm}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}
			\ {\color{theoremnumber}##2}
		\theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}
			\ {\color{theoremnumber}##2}
			\ {\color{theoremtitle}{\normalfont\scshape{(##3)}}}
		\theorem@separator}\hbox{\strut}}}]}
\newtheoremstyle{nonumbermythm}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}
		\theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}
			\ {\color{theoremtitle}{\normalfont\scshape{(##3)}}}
		\theorem@separator}\hbox{\strut}}}]}
\theoremstyle{mythm} 								% Vordefinierter Style mit Zeilenumbruch


\cs_if_exist:NTF \theorempreskip {
	\theorempreskip{1.0em}                               % Abstand vor Theorem
	\theorempostskip{1.0em}                               % Abstand vor Theorem
}{
	\theorempreskipamount 1.0em                               % Abstand vor Theorem
	\theorempostskipamount 1.0em                               % Abstand vor Theorem
}
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
\newtheorem{kor}[thm]{Korollar}
\renewtheorem*{kor*}{Korollar}
\newtheorem{prop}[thm]{Proposition}
\renewtheorem*{prop*}{Proposition}
\newtheorem{alg}[thm]{Algorithmus}
\renewtheorem*{alg*}{Algorithmus}

\newtheorem{nt}[thm]{Bemerkung}
\renewtheorem*{nt*}{Bemerkung}
\newtheorem{ex}[thm]{Beispiel}
\renewtheorem*{ex*}{Beispiel}

\cs_if_exist:NTF \theorempreskip {
	\theorempreskip{0.7em}                               % Abstand vor Theorem
}{
	\theorempreskipamount 0.7em                               % Abstand vor Theorem
}
\theoremheaderfont{\kern-1em\bfseries\small\itshape} % Kursiv und kleiner als oben

\theoremstyle{break}
\newtheorem*{note}{\color{headings}Bemerkung}

% Proof-Environment
% =================
% Führt \captions<lang> aus für \proofname, etc.
\csname captions\l_mycourse_language \endcsname
% Scheinbar wird \proofname überschrieben, wenn optionales Argument an \begin{proof} gegeben wird
\let\myproofname\proofname
\theoremsymbol{\ensuremath{\square}}
\theoremstyle{break}
\newtheorem* { proof } {
	\color { headings }
	\noexpand{\myproofname}
	:
}
\theoremsymbol{}


% Segment-Environment für kleinere gedankliche Abschnitte
% =======================================================

\newlist { segmentlist } { description } { 2 }
\setlist [ segmentlist ] {
	style       = nextline,
	labelindent = 0.0em,
	leftmargin  = 1em,
}
% Mit Zeilenumbruch
\DeclareDocumentEnvironment { seg } { og } {
	\begin{segmentlist} [ ]
		\item [ \mbox{ \color{headings} \IfNoValueTF { #1 } { #2 } { #1 } } ]
} {
	\end{segmentlist}
}
% Ohne Zeilenumbruch
\DeclareDocumentEnvironment { segnb } { og } {
	\begin{segmentlist} [
		style      = sameline,
		leftmargin = 2em,
		itemindent = *,
	]
		\item [ \mbox{ \color{headings} \IfNoValueTF { #1 } { #2 } { #1 } :} ]
} {
	\end{segmentlist}
}

%\newlist { proofpart } { description } { 1 }
%\setlist [ proofpart ] {
%	style       = sameline,
%	labelindent = 0.0em,
%	font        = \normalfont
%}


\RequirePackage{fancyhdr}
\RequirePackage{calc}
\pagestyle{fancy}

\fancyhead{}
\fancyfoot{}

\fancyheadoffset[RE,LO]{\marginparsep+\marginparwidth}
%\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
%\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}
\DeclareDocumentCommand {\l_mycourse_headvertbar} {} { \;{\color{headerrule}\rule[-0.4em]{0.7pt}{1.3em}}\; }
\RenewDocumentCommand { \chaptermark } { m } {
	\markboth { \ \thechapter ~ \l_mycourse_headvertbar ~ #1 } { }
}
\RenewDocumentCommand { \sectionmark } { m } {
	\markright { #1 ~ \l_mycourse_headvertbar ~ \thesection ~ \ }
}
\fancyhf{}
\newcommand{\headerfont}{\bfseries \scshape \color{header}}
\fancyfoot[LE,RO]{\bfseries\color{header} \thepage}
\fancyhead[RO]{\headerfont\rightmark}
\fancyhead[LE]{\headerfont\leftmark}
\renewcommand{\headrulewidth}{0.7pt}

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

\RequirePackage{lastpage}


%%=======================================================================
%% Titlepage
%%=======================================================================

\RequirePackage { xcoffins }
\RequirePackage { titling }

\newlength { \l_mycourse_titlepreskip }
\newlength { \l_mycourse_titlebarwidth }

\setlength { \l_mycourse_titlepreskip } { \textheight * \real{0.382} - 5pc}
\setlength { \l_mycourse_titlebarwidth } { \paperheight * \real{0.0147} }

\DeclareDocumentCommand { \maketitle } { } {

    \begin{titlepage}
        \NewCoffin \tpresult

        \NewCoffin \tptitle
        \NewCoffin \tpsubtitle
        \NewCoffin \tptimeplace

        \NewCoffin \tpruletop


        \SetHorizontalCoffin \tptitle {
            \parbox [ b ] { \textwidth } {
                \raggedright
                \fontsize { 35pt } { 35pt } \selectfont
                \vskip \l_mycourse_titlepreskip
                \thetitle
            }
        }
        \SetHorizontalCoffin \tpsubtitle {
            \parbox [ t ] { 0.5\textwidth } {
                \raggedright
                \fontsize { 16pt } { 18pt } \selectfont \scshape
                Vorlesungsmitschrieb
            }
        }
        \SetHorizontalCoffin \tptimeplace {
            \parbox [ t ] { 0.5\textwidth } {
                \raggedleft
                \fontsize { 10pt } { 12pt } \selectfont \scshape
                Universität~Stuttgart\\
		\l_mycourse_semester
            }
        }

        \SetHorizontalCoffin \tpruletop {
            \color { headerrule }
            \rule { \paperwidth } { \l_mycourse_titlebarwidth }
        }

        \JoinCoffins* \tpresult                              \tpruletop
        \JoinCoffins  \tpresult [\tpruletop-t,\tpruletop-l]  \tptitle     [B,l] (0pt       , 3.5mm)
        \JoinCoffins  \tpresult [\tpruletop-b,\tpruletop-l]  \tpsubtitle  [T,l] (0pt       ,-6mm)
        \JoinCoffins* \tpresult [\tpruletop-b,\tpruletop-l]  \tptimeplace [T,r] (\textwidth,-6mm)

        \TypesetCoffin \tpresult

    \end{titlepage}

}


% vim: sw=4
