\RequirePackage [ log-declarations = false ] { xparse }
\RequirePackage { expl3, l3keys2e }
\ProvidesExplClass {mythesis} { 2014/11/11 } { 0.1 }
    { A thesis template }

%%=======================================================================
%% Appearance and Configs
%%=======================================================================

%\ExplSyntaxOff
%\PassOptionsToClass { parskip = half+ } { scrartcl }
%\AtBeginDocument{
%    \setparsizes{0pt}{0.8ex}{0pt plus 1fil}
%}
%\ExplSyntaxOn

%%=======================================================================
%% Basic Requirements
%%=======================================================================

% Load base class
\LoadClass { scrartcl }

\PassOptionsToPackage {
    a4paper,
    outer          = 21mm,
    inner          = 21mm,
    top            = 20mm,
    bottom         = 30mm,
    marginparwidth = 18mm,
    marginparsep   =  3mm,
} { geometry }
\RequirePackage { geometry }


\RequirePackage [ l2tabu, orthodox ] { nag }
\RequirePackage { scrhack }

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
\setmonofont [
    Ligatures   = TeX,
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
] { Inconsolatazi4 }

\RequirePackage { microtype }

\RequirePackage { polyglossia }

\RequirePackage { amsmath, amssymb }

\RequirePackage { subcaption } % subfigure environment
\RequirePackage [ hypcap ] { caption }

%%=======================================================================
%% Index / Glossary
%%=======================================================================


\RequirePackage{hyperref}                       % Macht Referenzen im pdf-Dokument anklickbar

\hypersetup{
%    colorlinks         = true,
%    pdfborder          = {0~0~0},
%    bookmarksnumbered  = true,
%    bookmarksopen      = true,
%    bookmarksopenlevel = 1,
%    pdfdisplaydoctitle = true,
%    linktoc            = all,
}

% PDF Meta-Informationen setzen
\AtBeginDocument {
    \hypersetup {
        pdftitle   = { \@title  },
        pdfsubject = { \@title  },
        pdfauthor  = { \@author },
    }
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

\RequirePackage [ shortlabels ] { enumitem }

%% These must be inside one \setlist definition
%\setlist {
%    leftmargin  = *,
%    labelindent = 0.5em, % Fallback for cases when leftmargin = * is set manually
%    % The following fixes leftmargin, sets a fixed distance of the label from
%    % the item and allows the label to extend to the left as needed
%    % (leftmargin=* should be set manually in cases where the label is too
%    % long, in which case the above labelindent gets used)
%    leftmargin  = 2.1em,
%    labelwidth  = 2.0em,
%    labelsep*   = 0.4em
%}
%\setlist [ enumerate ] { leftmargin = 2.1em }
%\setlist [ itemize ] { leftmargin = 1.6em }
%\setlist [ description ] {
%    style       = nextline,
%    labelindent = 0.9em,
%    leftmargin  = 2.5em,
%    font        = \normalfont\small\bfseries,
%}

%%=======================================================================
%% Figures
%%=======================================================================

\DeclareDocumentCommand { \IncludeFigure } { o } {
	% TODO: load <#1>.tex from subfolder
}

%%=======================================================================
%% Algorithms
%%=======================================================================

\DeclareDocumentCommand { \Code } { m } { \texttt{#1} }


%%=======================================================================
%% Theorems (TODO: extra package?)
%%=======================================================================

%\RequirePackage{mathtools}
%\RequirePackage[amsmath,hyperref,thmmarks]{ntheorem}
%\RequirePackage{tikz}


%%=======================================================================
%% Headers / Footers
%%=======================================================================

\RequirePackage [
%    olines, % align lines at the textarea outside
] { scrpage2 }

\pagestyle { scrheadings }
\clearscrheadfoot

% specify content
%\ohead { \headmark }
%\ofoot [ \pagemark ] { \pagemark }

%% specify fonts
%\RenewDocumentCommand { \headfont } { } {
%    \bfseries \scshape \color { header }
%}
%\RenewDocumentCommand { \pnumfont } { } {
%    \bfseries \color { header }
%}

% line below header
%\setheadsepline [ page ] { 1pt } [ \color { headerrule } ]

%\RenewDocumentCommand { \chaptermark } { m } {
%    \markboth { \ \thechapter ~ \l_mycourse_headvertbar: ~ #1 } { }
%}
%\RenewDocumentCommand { \sectionmark } { m } {
%    \markright { #1 ~ \l_mycourse_headvertbar: ~ \thesection ~ \ }
%}


%%=======================================================================
%% Common Math Things
%%=======================================================================

\RequirePackage{mymath}

%%=======================================================================
%% Titlepage
%%=======================================================================


%%=======================================================================
%% Extras
%%=======================================================================

