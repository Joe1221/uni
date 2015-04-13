\RequirePackage [ log-declarations = false ] { xparse }
\RequirePackage { expl3, l3keys2e }
\ProvidesExplClass {mythesis} { 2014/11/11 } { 0.1 }
    { A thesis template }

%%=======================================================================
%% Appearance and Configs
%%=======================================================================

\ExplSyntaxOff
\PassOptionsToClass { parskip = half+} { scrbook }
\AtBeginDocument{
    \setparsizes{0pt}{0.7ex}{0pt plus 1fil}
}
\ExplSyntaxOn

%%=======================================================================
%% Basic Requirements
%%=======================================================================

% Load base class
\LoadClass [fontsize=12]{ scrbook }

\RequirePackage { xcolor }

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

\ExplSyntaxOff
\setmainlanguage [
    spelling        = new,
    latesthyphen    = true,
    babelshorthands = true,
] {german}
\ExplSyntaxOn
%%=======================================================================
%% Index / Glossary
%%=======================================================================


\RequirePackage{hyperref}                       % Macht Referenzen im pdf-Dokument anklickbar

\hypersetup{
    hidelinks
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

% emphasize a definition term and create index entry simultaneously
\DeclareDocumentCommand { \emphdef } { om } {
    %\index [ terms ] {
    %    \IfNoValueTF { #1 } { #2 } { #1 }
    %}
    \emph { #2 }
}

%%=======================================================================
%% Items / Enumerations
%%=======================================================================

\RequirePackage [ shortlabels, inline ] { enumitem }

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

\RequirePackage { tikz }
\tikzset {
    > = stealth,
}

%\definecolor{main1}{rgb}{0.05,0.4,0}
%\definecolor{hl1}{rgb}{0.9,0.1,0}
\definecolor{main1}{rgb}{0.0,0.0,0.7}
\definecolor{hl1}{rgb}{0.8,0.1,0.0}
\definecolor{red}{RGB}{180,0,0}
\definecolor{green}{RGB}{0,150,0}
\definecolor{blue}{RGB}{0,0,180}

\DeclareDocumentCommand { \IncludeFigure } { o } {
	% TODO: load <#1>.tex from subfolder
}

%%=======================================================================
%% Algorithms
%%=======================================================================

\definecolor{algcomment}{HTML}{444444}
\definecolor{algcommand}{HTML}{000055}

\DeclareDocumentCommand { \Code } { m } { \texttt{#1} }

\RequirePackage{algpseudocode}
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

\DeclareDocumentCommand { \Input }  { m } { { \small\itshape\bfseries Input: } ~ #1 }
\DeclareDocumentCommand { \Output } { m } { { \small\itshape\bfseries Output: } ~ #1 }


%%=======================================================================
%% Theorems (TODO: extra package?)
%%=======================================================================

%\RequirePackage{mathtools}
\RequirePackage[amsmath,hyperref,thmmarks]{ntheorem}

\theoremstyle{break}
\theoremindent=1em
\theorembodyfont{\normalfont}
\theoremheaderfont{\kern-1em\normalfont\bfseries}

\newcounter{thm}
\numberwithin{thm}{chapter}
\numberwithin{equation}{chapter}

\newtheorem{definition}[thm]{Definition}
\newtheorem{proposition}[thm]{Satz}
\newtheorem{algorithm}[thm]{Algorithmus}
\newtheorem{example}[thm]{Beispiel}
\newtheorem{lemma}[thm]{Lemma}
\newtheorem{theorem}[thm]{Theorem}
\newtheorem{corollary}[thm]{Korollar}
\newtheorem{remark}[thm]{Bemerkung}

\theoremheaderfont{\kern-1em\normalfont\small\itshape\bfseries}
\newtheorem*{proof}{Beweis:}
\newtheorem*{note}{Bemerkung}

%\RequirePackage{tikz}


%%=======================================================================
%% Headers / Footers
%%=======================================================================

\RequirePackage [
%    olines, % align lines at the textarea outside
] { scrlayer-scrpage }

\pagestyle { scrheadings }
%\clearscrheadfoot

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

