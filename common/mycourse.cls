\RequirePackage [ log-declarations = false ] { xparse }
\RequirePackage { expl3, l3keys2e }
\ProvidesExplClass {mycourse} {2013/11/16} {0.1}
    {Class intended for math courses}
\RequirePackage { l3backports }

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
    % ---------------------------------
    noproofs .code:n         =
        \AtEndOfClass{
            \RequirePackage{environ}
            \let\proof\relax
            \let\endproof\relax
            \NewEnviron{proof}{}
        }
    ,

    % [lang] Language option (ngerman, english, …)
    % --------------------------------------------
    lang .tl_set:N           = \l_mycourse_language,

    % [paper-size] (a4, a5) Controls the output paper size
    % ----------------------------------------------------
    paper-size .choice:,
    paper-size / a4 .code:n  =
        \PassOptionsToPackage {
            a4paper,
            outer          = 21mm,
            inner          = 21mm,
            top            = 20mm,
            bottom         = 30mm,
            marginparwidth = 18mm,
            marginparsep   =  3mm,
        } { geometry }
        \PassOptionsToPackage { scaled = 0.83 } { beramono }
        \PassOptionsToClass { fontsize = 12pt } { scrbook }
    ,
    paper-size / a5 .code:n  =
        \PassOptionsToPackage{
            reset,
            a5paper,
            top            = 14mm,
            bottom         = 21mm,
            left           = 16mm,
            right          = 16mm,
            footskip       = 07mm,
            headsep        = 03mm,
            marginparwidth = 17mm,
            marginparsep   =  2mm,
        } { geometry }
        \PassOptionsToPackage { scaled = 0.83 } { beramono }
        \PassOptionsToClass { fontsize = 10pt } { scrbook }
    ,
    % Shorthands
    a5 .code:n               = \keys_set:nn { mycourse } { paper-size = a5 },
    a4 .code:n               = \keys_set:nn { mycourse } { paper-size = a4 },
    book .code:n             =
        \keys_set:nn { mycourse } {
            paper-size = a5,
            style      = default-print,
        }
    ,

    % [style] (dark,default,default-print)
    % ------------------------------------
    style .tl_set:N          = \l_mycourse_style,

    % [semester] Course semester, shown on titlepage
    % ----------------------------------------------
    semester .tl_set:N       = \l_mycourse_semester,

}

% Option Defaults
% -----------------------------------------------------------------------
\keys_set:nn { mycourse } {
    lang       = german,
    paper-size = a5,
    style      = ,
    semester   = ,
}

% Load configuration file, containing additional options, e.g. in the form
% \PassOptionsToClass{paper-format=a4}{mycourse}
% ------------------------------------------------------------------------
\file_if_exist:nTF { config } {
    \file_input:n { config }
    \msg_info:nn { mycourse } { config_loaded }
}{
    \msg_info:nn { mycourse } { config_missing }
}

% Finally process options passed to this class
\ProcessKeysOptions { mycourse }



%%=======================================================================
%% Info Parsing
%%=======================================================================

\cs_new:Nn \mycourse_set_lastchanged:n {
    \clist_set:Nn \l_lastchanged_cl { #1 }
    \tl_clear_new:N \l_part_tl

    \prop_clear_new:N \mycourse_lastchanged_pl
    \clist_pop:NN \l_lastchanged_cl \l_part_tl
    \prop_put:NnV \mycourse_lastchanged_pl { year } { \l_part_tl }
    \clist_pop:NN \l_lastchanged_cl \l_part_tl
    \prop_put:NnV \mycourse_lastchanged_pl { month } { \l_part_tl }
    \clist_pop:NN \l_lastchanged_cl \l_part_tl
    \prop_put:NnV \mycourse_lastchanged_pl { day } { \l_part_tl }
    \clist_pop:NN \l_lastchanged_cl \l_part_tl
    \prop_put:NnV \mycourse_lastchanged_pl { hour } { \l_part_tl }
    \clist_pop:NN \l_lastchanged_cl \l_part_tl
    \prop_put:NnV \mycourse_lastchanged_pl { minute } { \l_part_tl }
    \clist_pop:NN \l_lastchanged_cl \l_part_tl
    \prop_put:NnV \mycourse_lastchanged_pl { second } { \l_part_tl }
}
\cs_new:Nn \mycourse_set_authors:n {
    \tl_clear_new:N \mycourse_authors_tl
    \tl_set:Nn \mycourse_authors_tl { #1 }
}

% Load info file, containing generated information, e.g.
% last commit date, git authors, etc.
% ------------------------------------------------------------------------
\file_if_exist:nT { info } {
    \file_input:n { info }
}


%%=======================================================================
%% Appearance and Configs
%%=======================================================================

% Entfernt Einrückung bei Absätzen und fügt stattdessen vertikalen Abstand ein
\ExplSyntaxOff
\PassOptionsToClass { parskip = half+ } { scrbook }
\AtBeginDocument{
    \setparsizes{0pt}{0.8ex}{0pt plus 1fil}
}
\ExplSyntaxOn

%%=======================================================================
%% Basic Requirements
%%=======================================================================

% Load base class
\LoadClass { scrbook }

% Old version of package libertine loads xcolor with conflicting options, so load it beforehand.
\RequirePackage [ svgnames, x11names ] { xcolor }  % ana3 needs x11names

%%=======================================================================
%% Fonts / Encoding / i18n
%%=======================================================================

\RequirePackage { fontspec }

\setmainfont [
    Ligatures      = TeX,
    Extension      = .otf,
    UprightFont    = *_R,
    BoldFont       = *_RB,
    ItalicFont     = *_RI,
    BoldItalicFont = *_RBI,
] { LinLibertine }

% Inconsolatazi4-* and package zi4 exists since texlive 2013,
% handle older distributions conditionally
\IfFileExists { zi4.sty } {
    \setmonofont [
        Ligatures   = TeX,
        Extension   = .otf,
        UprightFont = *-Regular,
        BoldFont    = *-Bold,
    ] { Inconsolatazi4 }
} {
    \setmonofont [
        Ligatures   = TeX
    ] { Inconsolata }
}

\RequirePackage { polyglossia }

\str_case:onF { \l_mycourse_language } {
    { german } {
        % Polyglossia babelshorthands has some problems with explsyntax
        \cs_new_eq:NN \mycourselanguage \l_mycourse_language
        \ExplSyntaxOff
        \setmainlanguage [
            spelling        = new,
            latesthyphen    = true,
            babelshorthands = true,
        ] { \mycourselanguage }
        \ExplSyntaxOn
    }
} {
    \setmainlanguage [
    ] { \l_mycourse_language }
}


\RequirePackage { etex }
\RequirePackage { datetime }

\RequirePackage { geometry }
\RequirePackage { graphicx }

\RequirePackage { amsmath, amssymb }

\RequirePackage [ l2tabu, orthodox ] { nag }  % Warnt vor Nutzung von veralteten Befehlen und Packages
\RequirePackage { scrhack }                        % Wegen float-package, das eine warnung mit scrbook erzeugt

\RequirePackage { float }              % Erlaubt [H] Option für table/figure (load before hyperref)
\RequirePackage [ hypcap ] { caption }
\RequirePackage { microtype }                      % Für typographische Perfektion

%%=======================================================================
%% Colors
%%=======================================================================

\file_input:n { colors/default }

\renewcommand*\sectfont{\sffamily\bfseries\color{headings}}

%%=======================================================================
%% Index / Glossary
%%=======================================================================

\RequirePackage [ xindy ] { imakeidx } % (before hyperref)

\makeindex [
    name = terms,
    title = Index, % fixme: i8n
    options = -I omega, % texindy has issues with utf8 otherwise
]
\makeindex [
    name = lectures,
    title = Vorlesungen, % fixme: i8n
    options = -I omega, % texindy has issues with utf8 otherwise
    %options = -I~omega~-M~indexstyle, % texindy has issues with utf8 otherwise
    columns = 1,
]

% emphasize a definition term and create index entry simultaneously
\DeclareDocumentCommand { \emphdef } { om } {
    \index [ terms ] {
        \IfNoValueTF { #1 } { #2 } { #1 }
    }
    { \color { termdef } \textit { #2 } }
}

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


%\RequirePackage[hidelinks]{hyperref}                   % Macht Referenzen im pdf-Dokument anklickbar
\RequirePackage{hyperref}                       % Macht Referenzen im pdf-Dokument anklickbar

\hypersetup{
    colorlinks         = true,
    pdfborder          = {0~0~0},
    bookmarksnumbered  = true,
    bookmarksopen      = true,
    bookmarksopenlevel = 1,
    pdfdisplaydoctitle = true,
    linktoc            = all,
    %allcolors         = link,
    urlcolor           = url,
    linkcolor          = link,
    citecolor          = link,
    runcolor           = link,
    menucolor          = link,
    filecolor          = link,
    anchorcolor        = link,
}

\newdateformat { mycoursepdfdate } {
    \THEYEAR
    \twodigit { \THEMONTH }
    \twodigit { \THEDAY }
}
\newtimeformat { mycoursepdftime } {
    \twodigit { \THEHOUR }
    \twodigit { \THEMINUTE }
    \twodigit { \THESECOND }
}
\prop_if_exist:NT \mycourse_lastchanged_pl {
    \tl_clear_new:N \l_year
    \tl_clear_new:N \l_month
    \tl_clear_new:N \l_day
    \tl_clear_new:N \l_hour
    \tl_clear_new:N \l_minute
    \prop_get:NnN \mycourse_lastchanged_pl { year } \l_year
    \prop_get:NnN \mycourse_lastchanged_pl { month } \l_month
    \prop_get:NnN \mycourse_lastchanged_pl { day } \l_day
    \prop_get:NnN \mycourse_lastchanged_pl { hour } \l_hour
    \prop_get:NnN \mycourse_lastchanged_pl { minute } \l_minute

    \mycoursepdfdate
    \settimeformat { mycoursepdftime }
    \hypersetup {
        pdfinfo = {
            ModDate = {
                D: \l_year \l_month \l_day \l_hour \l_minute 00
            },
        },
    }
}

% PDF Meta-Informationen setzen
\AtBeginDocument {
    \hypersetup {
        pdftitle   = { \@title  },
        pdfsubject = { \@title  },
        pdfauthor  = { \@author },
    }
    % Set text color and LaTeX default color (used in tables and other parts)
    \color{text}\global\let\default@color\current@color
    \pagecolor{background}
    %\everymath{\color{math}} % Currently broken, looking for clean, working solution
}

\AtBeginDocument {
    % Erzeuge pdf-bookmark für die Titelseite
    %\cs_new_eq:NN \maketitle_old \maketitle
    %\DeclareDocumentCommand { \maketitle } { } {
    %    %\cleardoublepage % keeps bookmark anchor and toc on same page
    %    \pdfbookmark [ 0 ] { Titelseite } { toc }
    %    \maketitle_old
    %}
    % Erzeuge pdf-bookmark für das Inhaltsverzeichnis
    \cs_new_eq:NN \tableofcontents_old \tableofcontents
    \DeclareDocumentCommand { \tableofcontents } { } {
        \cleardoublepage % keeps bookmark anchor and toc on same page
        \pdfbookmark [ 0 ] { \contentsname } { toc }
        \tableofcontents_old
    }
}

%%=======================================================================
%% Items / Enumerations
%%=======================================================================

\RequirePackage [ shortlabels, inline ] { enumitem }     % Aufzählungen wie a), (I), etc. als optionales Argument

% These must be inside one \setlist definition
\setlist {
    leftmargin  = *,
    labelindent = 0.5em, % Fallback for cases when leftmargin = * is set manually
    % The following fixes leftmargin, sets a fixed distance of the label from
    % the item and allows the label to extend to the left as needed
    % (leftmargin=* should be set manually in cases where the label is too
    % long, in which case the above labelindent gets used)
    leftmargin  = 2.1em,
    labelwidth  = 2.0em,
    labelsep*   = 0.4em
}
\setlist [ enumerate ] { leftmargin = 2.1em }
\setlist [ itemize ] { leftmargin = 1.6em }
\setlist [ description ] {
    style       = nextline,
    labelindent = 0.9em,
    leftmargin  = 2.5em,
    font        = \normalfont\small\bfseries,
}

%%=======================================================================
%% Figures
%%=======================================================================

\DeclareDocumentCommand { \IncludeFigure } { o } {
	% TODO: load <#1>.tex from subfolder
}

%%=======================================================================
%% Algorithms
%%=======================================================================

\RequirePackage{algpseudocode}          % algorithmicx package für Pseudo-Code
\RequirePackage{verbatim}                       % Für Ascii-Art ;-)

\cs_new:Nn \mycourse_algcommand_style: { \ttfamily \color{algcommand} }

\algrenewcommand { \algorithmiccomment } [ 1 ] {
    \hfill \mbox {
        » ~ { \slshape \color { algcomment } #1 }
    }
}
\algrenewcommand { \algorithmicwhile  } { { \mycourse_algcommand_style: while  } }
\algrenewcommand { \algorithmicdo     } { { \mycourse_algcommand_style: do     } }
\algrenewcommand { \algorithmicend    } { { \mycourse_algcommand_style: end    } }
\algrenewcommand { \algorithmicfor    } { { \mycourse_algcommand_style: for    } }
\algrenewcommand { \algorithmicif     } { { \mycourse_algcommand_style: if     } }
\algrenewcommand { \algorithmicthen   } { { \mycourse_algcommand_style: then   } }
\algrenewcommand { \algorithmicelse   } { { \mycourse_algcommand_style: else   } }
\algrenewcommand { \algorithmicrepeat } { { \mycourse_algcommand_style: repeat } }
\algrenewcommand { \algorithmicuntil  } { { \mycourse_algcommand_style: until  } }
\DeclareDocumentCommand { \Return } { m } { \State { \mycourse_algcommand_style: return} ~ #1 }

\RequirePackage{listings}                       % Einbinden von Code-Schnipsel
% Hack um deutsche Sonderzeichen in lstinputlisting zu unterstützen
\lstset{literate={Ö}{{\"O}}1{Ä}{{\"A}}1{Ü}{{\"U}}1{ß}{{\ss}}2{ü}{{\"u}}1{ä}{{\"a}}1{ö}{{\"o}}1}
\lstset{
    basicstyle       = \ttfamily,
    numbers          = left,
    columns          = fullflexible,
    breaklines       = true,
    mathescape       = true,
    escapechar       = \#,
    tabsize          = 4,
    frame            = lines,
    showstringspaces = false
}


%%=======================================================================
%% Theorems (TODO: extra package?)
%%=======================================================================

%\RequirePackage{mathtools}
\RequirePackage[amsmath,hyperref,thmmarks]{ntheorem}                    % Alternative theorems für leichteres Anpassen
\RequirePackage{tikz}

% TODO: \theoremheadertypefont{bla} sollte funktionieren, wie?
\def\theorem@headertypefont{\color{theoremtype}} % Font für Theorem-Typ (Satz, Definition, etc.)

% Hack to prevent bold math in theorem title (TODO: not needed?)
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
\theoremstyle{mythm}                                                            % Vordefinierter Style mit Zeilenumbruch


\cs_if_exist:NTF \theorempreskip {
        \theorempreskip{1.0em}                               % Abstand vor Theorem
        \theorempostskip{1.0em}                               % Abstand vor Theorem
}{
        \theorempreskipamount 1.0em                               % Abstand vor Theorem
        \theorempostskipamount 1.0em                               % Abstand vor Theorem
}
\theoremindent 1em                                                                      % Theroem einrücken
\theoremheaderfont{\kern-1em\normalfont\bfseries}       % Überschrift wieder ausrücken
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
\newtheorem{conj}[thm]{Vermutung}
\renewtheorem*{conj*}{Vermutung}

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
    \begin{segmentlist} [
        font       = \normalfont\small\bfseries\boldmath,
    ]
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
        font       = \normalfont\small\bfseries\boldmath,
    ]
        \item [ \mbox{ \color{headings} \IfNoValueTF { #1 } { #2 } { #1 } :} ]
} {
    \end{segmentlist}
}

%\newlist { proofpart } { description } { 1 }
%\setlist [ proofpart ] {
%       style       = sameline,
%       labelindent = 0.0em,
%       font        = \normalfont
%}

\RequirePackage{calc}

%%=======================================================================
%% Headers / Footers
%%=======================================================================

\RequirePackage [
    olines, % align lines at the textarea outside
] { scrpage2 }

\pagestyle { scrheadings }
\clearscrheadfoot

% specify content
\ohead { \headmark }
\ofoot [ \pagemark ] { \pagemark }

% specify fonts
\RenewDocumentCommand { \headfont } { } {
    \bfseries \scshape \color { header }
}
\RenewDocumentCommand { \pnumfont } { } {
    \bfseries \color { header }
}

% line below header
\setheadsepline [ page ] { 1pt } [ \color { headerrule } ]

% vertical bar used between section number and section text
\cs_new:Nn \l_mycourse_headvertbar: {
    \; {
        %\color { headerrule } \rule [ -0.4em ] { 1pt } { 1.3em }
        |
    } \;
}

% redefine appearance to include headvertbar from above
\RenewDocumentCommand { \chaptermark } { m } {
    \markboth { \ \thechapter ~ \l_mycourse_headvertbar: ~ #1 } { }
}
\RenewDocumentCommand { \sectionmark } { m } {
    \markright { #1 ~ \l_mycourse_headvertbar: ~ \thesection ~ \ }
}


%%=======================================================================
%% Common Math Things
%%=======================================================================

\RequirePackage{mymath}

\RequirePackage{lastpage}


%%=======================================================================
%% Titlepage
%%=======================================================================

\newdateformat { mycoursedate } {
    \twodigit { \THEDAY } .
    \twodigit { \THEMONTH } .
    \THEYEAR
}
\newtimeformat { mycoursetime } {
    \twodigit { \THEHOUR } :
    \twodigit { \THEMINUTE }
}

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
        \NewCoffin \tpinfo

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
        \SetHorizontalCoffin \tpinfo {
            \mycoursedate
            \settimeformat { mycoursetime }
            \parbox [ t ] { 0.5\textwidth } {
                \raggedright
                \fontsize { 10pt } { 12pt } \selectfont \scshape
                Autoren:~
                %\fontsize { 6pt } { 10pt } \selectfont \normalfont
                %(in~Reihenfolge~ihrer~Beitragsmenge) \\

                \fontsize { 8pt } { 10pt } \selectfont \normalfont
                \begin{addmargin} [ 1.2em ] { 0cm }
                    \tl_if_exist:NT \mycourse_authors_tl {
                        \mycourse_authors_tl
                    }
                \end{addmargin}
            }
            \parbox [ t ] { 0.5\textwidth } {
                \raggedleft
                \fontsize { 8pt } { 10pt } \selectfont
                Kompiliert: ~ \today \; \currenttime \\

                \prop_if_exist:NT \mycourse_lastchanged_pl {
                    \tl_clear_new:N \l_year
                    \tl_clear_new:N \l_month
                    \tl_clear_new:N \l_day
                    \tl_clear_new:N \l_hour
                    \tl_clear_new:N \l_minute
                    \prop_get:NnN \mycourse_lastchanged_pl { year } \l_year
                    \prop_get:NnN \mycourse_lastchanged_pl { month } \l_month
                    \prop_get:NnN \mycourse_lastchanged_pl { day } \l_day
                    \prop_get:NnN \mycourse_lastchanged_pl { hour } \l_hour
                    \prop_get:NnN \mycourse_lastchanged_pl { minute } \l_minute

                    Letzte~inhaltliche~Änderung: ~
                    \formatdate { \l_day } { \l_month } { \l_year } \;
                    \formattime { \l_hour } { \l_minute } { 0 }
                    \\
                }

                \vskip 1em
                \url{https://github.com/stev47/uni} \\
            }
        }

        \SetHorizontalCoffin \tpruletop {
            \color { headerrule }
            \rule { \paperwidth } { \l_mycourse_titlebarwidth }
        }

        \JoinCoffins* \tpresult                              \tpruletop
        \JoinCoffins  \tpresult [\tpruletop-t,\tpruletop-l]  \tptitle     [B,l] (0mm       , 3.5mm)
        \JoinCoffins  \tpresult [\tpruletop-b,\tpruletop-l]  \tpsubtitle  [T,l] (0.2mm     ,-6mm)
        \JoinCoffins* \tpresult [\tpruletop-b,\tpruletop-l]  \tptimeplace [T,r] (\textwidth,-6mm)
        \JoinCoffins  \tpresult [\tpruletop-b,\tpruletop-l]  \tpinfo      [T,r] (\textwidth,-15mm)

        \TypesetCoffin \tpresult

    \end{titlepage}

}

%%=======================================================================
%% Extras
%%=======================================================================

\DeclareDocumentCommand { \Exercise } { } {
    % stub
}

% vim: sw=4
